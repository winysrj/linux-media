Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:44393 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbZK3R6o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 30 Nov 2009 12:58:44 -0500
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: Hans Verkuil <hverkuil@xs4all.nl>,
	"santiago.nunez@ridgerun.com" <santiago.nunez@ridgerun.com>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	"Narnakaje, Snehaprabha" <nsnehaprabha@ti.com>,
	"diego.dompe@ridgerun.com" <diego.dompe@ridgerun.com>,
	"todd.fischer@ridgerun.com" <todd.fischer@ridgerun.com>,
	"Grosen, Mark" <mgrosen@ti.com>
Date: Mon, 30 Nov 2009 11:58:36 -0600
Subject: RE: [PATCH 3/4 v8] TVP7002 driver for DM365
Message-ID: <A69FA2915331DC488A831521EAE36FE40155AD7C52@dlee06.ent.ti.com>
References: <1259177960-14913-1-git-send-email-santiago.nunez@ridgerun.com>
 <200911252231.23458.hverkuil@xs4all.nl>
In-Reply-To: <200911252231.23458.hverkuil@xs4all.nl>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hans,

>
>Note: Murali made a new function that will fill in the v4l2_dv_enum_preset
>based on the preset value. It's not yet in the v4l-dvb repository although
>I hope that the timing patches will go in soon. The only thing I'm waiting
>for is the revised documentation patch.
>
I will try to spend some time on these this week.

>BTW: I think we need a g_dv_preset ops as well. That seems to be missing.
>Murali,
>is there any reason why we do not have that?

One reason is we don't have a g_std() ops since core maintains the current
norm. Other reason is at this point I don't see why we need this since bridge device driver is going to save the current std or current dv_preset set by application if s_std() or s_dv_preset() is successful. So if application calls G_DV_PRESET, bridge device driver will return the last
successful std or dv_preset value. If we really need it for some reason, we could add it later when we integrate the vpfe/vpif drivers with this driver. 
>
>> +		}
>
>Did you check whether it is really needed to power the chip off and on
>here?
>
>It still makes no sense to me that you have to do this.


Can we make this a TODO item which can be addressed later? This driver is
holding up my vpfe enhancements to support HD. This works functionally
and we can always enhance the driver as required. So I suggest to keep
this as a TODO item and address later using another patch.
>>
>
Murali
