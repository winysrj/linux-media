Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:37254 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764157AbZFOQBM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 15 Jun 2009 12:01:12 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Magnus Damm <magnus.damm@gmail.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
Date: Mon, 15 Jun 2009 11:01:07 -0500
Subject: RE: [PATCH RFC] adding support for setting bus parameters in sub
 	device
Message-ID: <A69FA2915331DC488A831521EAE36FE40139DF92A6@dlee06.ent.ti.com>
References: <1244580953-24188-1-git-send-email-m-karicheri2@ti.com>
 <aec7e5c30906142157t313e7c95v3d1ab19f80745cf5@mail.gmail.com>
In-Reply-To: <aec7e5c30906142157t313e7c95v3d1ab19f80745cf5@mail.gmail.com>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> +
>> +struct v4l2_subdev_bus {
>> +       enum v4l2_subdev_bus_type type;
>> +       u8 width;
>> +       /* 0 - active low, 1 - active high */
>> +       unsigned pol_vsync:1;
>> +       /* 0 - active low, 1 - active high */
>> +       unsigned pol_hsync:1;
>> +       /* 0 - low to high , 1 - high to low */
>> +       unsigned pol_field:1;
>> +       /* 0 - sample at falling edge , 1 - sample at rising edge */
>> +       unsigned pol_pclock:1;
>> +       /* 0 - active low , 1 - active high */
>> +       unsigned pol_data:1;
>> +};
>
>As for the pins/signals, I wonder if per-signal polarity/edge is
>enough. If this is going to be used by/replace the soc_camera
>interface then we also need to know if the signal is present or not.
>For instance, I have a SuperH board using my CEU driver together with
>one OV7725 camera or one TW9910 video decoder. Some revisions of the
>board do not route the field signal between the SuperH on-chip CEU and
>the TW9910. Both the CEU and the TW9910 support this signal, it just
>happen to be missing. 

[MK]In that case can't the driver just ignore the field polarity? I assume that drivers implement the parameter that has support in hardware. So it is not an issue.

I think we need a way to include this board
>specific property somehow.
>

>/ magnus

