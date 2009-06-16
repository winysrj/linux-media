Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:51872 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZFPECR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 16 Jun 2009 00:02:17 -0400
Received: by gxk10 with SMTP id 10so7367729gxk.13
        for <linux-media@vger.kernel.org>; Mon, 15 Jun 2009 21:02:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <A69FA2915331DC488A831521EAE36FE40139DF92A6@dlee06.ent.ti.com>
References: <1244580953-24188-1-git-send-email-m-karicheri2@ti.com>
	 <aec7e5c30906142157t313e7c95v3d1ab19f80745cf5@mail.gmail.com>
	 <A69FA2915331DC488A831521EAE36FE40139DF92A6@dlee06.ent.ti.com>
Date: Tue, 16 Jun 2009 13:02:17 +0900
Message-ID: <aec7e5c30906152102r27aa2894q857be2ffb30d1d45@mail.gmail.com>
Subject: Re: [PATCH RFC] adding support for setting bus parameters in sub
	device
From: Magnus Damm <magnus.damm@gmail.com>
To: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Jun 16, 2009 at 1:01 AM, Karicheri,
Muralidharan<m-karicheri2@ti.com> wrote:
>>> +
>>> +struct v4l2_subdev_bus {
>>> +       enum v4l2_subdev_bus_type type;
>>> +       u8 width;
>>> +       /* 0 - active low, 1 - active high */
>>> +       unsigned pol_vsync:1;
>>> +       /* 0 - active low, 1 - active high */
>>> +       unsigned pol_hsync:1;
>>> +       /* 0 - low to high , 1 - high to low */
>>> +       unsigned pol_field:1;
>>> +       /* 0 - sample at falling edge , 1 - sample at rising edge */
>>> +       unsigned pol_pclock:1;
>>> +       /* 0 - active low , 1 - active high */
>>> +       unsigned pol_data:1;
>>> +};
>>
>>As for the pins/signals, I wonder if per-signal polarity/edge is
>>enough. If this is going to be used by/replace the soc_camera
>>interface then we also need to know if the signal is present or not.
>>For instance, I have a SuperH board using my CEU driver together with
>>one OV7725 camera or one TW9910 video decoder. Some revisions of the
>>board do not route the field signal between the SuperH on-chip CEU and
>>the TW9910. Both the CEU and the TW9910 support this signal, it just
>>happen to be missing.
>
> [MK]In that case can't the driver just ignore the field polarity? I assume that drivers implement the parameter that has support in hardware. So it is not an issue.

No, because the same driver runs on hardware that also has the field
signal. So we need to be able to give information about which signals
that the board actually implement. We already do this with the
soc_camera framework and it is working just fine.

Thanks for your comment!

/ magnus
