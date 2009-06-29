Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:39943 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759561AbZF2OXd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 29 Jun 2009 10:23:33 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: David Brownell <david-b@pacbell.net>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>
CC: Hans Verkuil <hverkuil@xs4all.nl>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Mon, 29 Jun 2009 09:23:28 -0500
Subject: RE: [PATCH 3/3 - v0] davinci: platform changes to support vpfe
 camera capture
Message-ID: <A69FA2915331DC488A831521EAE36FE401448CDD97@dlee06.ent.ti.com>
References: <1246053948-8371-1-git-send-email-m-karicheri2@ti.com>
 <200906271419.43942.hverkuil@xs4all.nl>
 <200906271042.01379.david-b@pacbell.net>
In-Reply-To: <200906271042.01379.david-b@pacbell.net>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

<snip>
>> >
>> > -static struct tvp514x_platform_data tvp5146_pdata = {
>> > -     .clk_polarity = 0,
>> > -     .hs_polarity = 1,
>> > -     .vs_polarity = 1
>
>Clearly this patch is against neither mainline nor the
>current DaVinci GIT tree... I suggest reissuing against
>mainline, now that it's got most DM355 stuff.
>
>
That is because, I have my first (vpfe capture version v3) patch lined up for merge to upstream/davinci git kernel and I have to keep working on my project. So only way I can do it is to apply my patch first on to the kernel tree and then create the new patches based on that. I understand I need to re-work this patch when it is ready to merge. I had also added following lines to my patch description to help the reviewers.

>>NOTE: Depends on v3 version of vpfe capture driver patch

What is your suggestion in such cases?

>> > +
>> > +static const struct i2c_device_id dm355evm_msp_ids[] = {
>> > +     { "dm355evm_msp", 0, },
>> > +     { /* end of list */ },
>> > +};
>
>Needless to say:  NAK on all this.  There is already a
>drivers/mfd/dm355evm_msp.c managing this device.  You
>shouldn't have video code crap all over it.
>
>It currently sets up for TVP5146 based capture iff that
>driver is configured (else the external imager); and
>exports the NTSC/nPAL switch setting as a GPIO that's
>also visible in sysfs.
>
>I suggest the first revision of this VPFE stuff use
>the existing setup.  A later patch could add some
>support for runtime reconfiguration.
>
I didn't know that you have a video code crap added to drivers/mfd/dm355evm_msp.c :)

The first patch is already out and is using TVP5146. So I will investigate your msp driver and see how I can support run time configuring the input.
If you have any suggestion let me know.

Wondering why you chose to make msp driver dm355 specific? MSP430 is available on dm6446 and dm355, right? 

Murali
