Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:55653 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753780AbbAOMdi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2015 07:33:38 -0500
Message-id: <54B7B39C.7080204@samsung.com>
Date: Thu, 15 Jan 2015 13:33:32 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Mark Brown <broonie@kernel.org>,
	Rob Herring <robherring2@gmail.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>,
	linux-leds@vger.kernel.org,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Kyungmin Park <kyungmin.park@samsung.com>,
	Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
	Pavel Machek <pavel@ucw.cz>, Bryan Wu <cooloney@gmail.com>,
	Richard Purdie <rpurdie@rpsys.net>, sakari.ailus@iki.fi,
	Rob Herring <robh+dt@kernel.org>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>,
	Liam Girdwood <lgirdwood@gmail.com>
Subject: Re: [PATCH/RFC v10 03/19] DT: leds: Add led-sources property
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-4-git-send-email-j.anaszewski@samsung.com>
 <CAL_JsqJKEp6TWaRhJimg3AWBh+MCCr2Bk9+1o7orLLdp5E+n-g@mail.gmail.com>
 <54B38682.5080605@samsung.com>
 <CAL_Jsq+UaA41DvawdOMmOib=Fi0hC-nBdKV-+P4DFo+MoOy-bQ@mail.gmail.com>
 <54B3F1EF.4060506@samsung.com>
 <CAL_JsqKpJtUG0G6g1GOuSVpc31oe-dp3qdrKJUE0upG-xRDFhA@mail.gmail.com>
 <20150112170644.GO4160@sirena.org.uk>
In-reply-to: <20150112170644.GO4160@sirena.org.uk>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 12/01/15 18:06, Mark Brown wrote:
> On Mon, Jan 12, 2015 at 10:55:29AM -0600, Rob Herring wrote:
>> > On Mon, Jan 12, 2015 at 10:10 AM, Jacek Anaszewski
>>> > > There are however devices that don't fall into this category, i.e. they
>>> > > have many outputs, that can be connected to a single LED or to many LEDs
>>> > > and the driver has to know what is the actual arrangement.
>> >
>> > We may need to extend the regulator binding slightly and allow for
>> > multiple phandles on a supply property, but wouldn't something like
>> > this work:
>> > led-supply = <&led-reg0>, <&led-reg1>, <&led-reg2>, <&led-reg3>;
>> > The shared source is already supported by the regulator binding.
>
> What is the reasoning for this?  If a single supply is being supplied by
> multiple regulators then in general those regulators will all know about
> each other at a hardware level and so from a functional and software
> point of view will effectively be one regulator.  If they don't/aren't
> then they tend to interfere with each other.

For LED current regulators like this one [1] we want to be able to 
communicate to the software the hardware wiring, e.g. if a single LED is 
connected to only one or both the current regulators.  The device needs 
to be programmed differently for each configuration, as shown on page 36 
of the datasheet [2].

Now, the LED DT binding describes the LEDs (current consumers) as child
nodes of the LED driver IC (current supplier), e.g. (from [3]):

pca9632@62 {
        compatible = "nxp,pca9632";
        #address-cells = <1>;
        #size-cells = <0>;
        reg = <0x62>;

        red@0 {
                label = "red";
                reg = <0>;
                linux,default-trigger = "none";
        };
        green@1 {
                label = "green";
                reg = <1>;
                linux,default-trigger = "none";
        };
	...
};

What is missing in this binding is the ability to tell that a single LED
is connected to more than one current source.

We could, for example adopt the multiple phandle in the supply property
scheme, but not use the kernel regulator API, e.g.

flash-led {
         compatible = "maxim,max77387";

         current-reg1 { // FLED1
                 led-output-id = <0>;
         };

         current-reg2 { // FLED2
                 led-output-id = <1>;
         };

         red_led {
                 led-supply = <&current-reg1>, <&current-reg2>;
         };
};

However my feeling is that it is unnecessarily complicated that way.

Perhaps we could use the 'reg' property to describe actual connections,
I'm not sure if it's better than a LED specific property, e.g.

max77387@52 {
        compatible = "nxp,max77387";
        #address-cells = <2>;
        #size-cells = <0>;
        reg = <0x52>;

	flash_led {
		reg = <1 1>;	
		...
	};	
};

[1] http://www.maximintegrated.com/en/products/power/led-drivers/MAX77387.html
[2] http://datasheets.maximintegrated.com/en/ds/MAX77387.pdf
[3] Documentation/devicetree/bindings/leds/pca963x.txt
