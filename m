Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:33471 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755223AbbBLLNh (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 12 Feb 2015 06:13:37 -0500
Received: by mail-we0-f181.google.com with SMTP id w62so9307918wes.12
        for <linux-media@vger.kernel.org>; Thu, 12 Feb 2015 03:13:36 -0800 (PST)
Date: Thu, 12 Feb 2015 11:11:33 +0000
From: Luis de Bethencourt <luis@debethencourt.com>
To: David =?utf-8?B?Q2ltYsWvcmVr?= <david.cimburek@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH] media: Pinnacle 73e infrared control stopped working
 since kernel 3.17
Message-ID: <20150212111133.GA3580@biggie>
References: <CAEmZozMOenY096OwgMgdL27hizp8Z26PJ_ZZRsq0DyNpSZam-g@mail.gmail.com>
 <20150212001034.GA1864@turing>
 <CAEmZozNL_GZtTVkJvn5sgteSaWoRV2fNNhboADiGJhJNCCh_Fw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEmZozNL_GZtTVkJvn5sgteSaWoRV2fNNhboADiGJhJNCCh_Fw@mail.gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Feb 12, 2015 at 08:15:10AM +0100, David Cimbůrek wrote:
> I'll try to describe my thoughts.
> 
> The changed structure "dib0700_rc_response" is used in
> dib0700_core.c:dib0700_rc_urb_completion(struct urb *purb) function:
> 
> struct dib0700_rc_response *poll_reply;
> ...
> poll_reply = purb->transfer_buffer;
> 
> dib0700_rc_urb_completion() is then used in
> dib0700_core.c:dib0700_rc_setup() in macros usb_fill_bulk_urb and
> usb_fill_int_urb. These macros are defined in header file usb.h. Here
> I have found in macro description this:
> 
>  * @transfer_buffer: pointer to the transfer buffer
> 
> I suppose that it means that the struct dib0700_rc_response is being
> filled from this transfer buffer. Therefore I suppose that the order
> of structure members IS important.
> 
> Of course it's only my guess but my patch is really working for me :-)
> 

Hi David,

I am away from the keyboard most of today. Busy with a training.

I will follow the code you describe as soon as I can in a few hours and report
back.

Thanks,
Luis

> 
> 
> 2015-02-12 1:10 GMT+01:00 Luis de Bethencourt <luis@debethencourt.com>:
> > On Tue, Feb 10, 2015 at 11:38:11AM +0100, David Cimbůrek wrote:
> >> Please include this patch to kernel! It takes too much time for such a
> >> simple fix!
> >>
> >
> > The patch is simple but why it fixes the issue isn't that simple. Could you
> > explain why the order of the variables inside the structure is breaking things?
> >
> > All the uses of the variables inside the structure that I can see are by name.
> > Not by memory offsets.
> >
> > Thanks,
> > Luis
> >
> >>
> >> 2015-01-07 13:51 GMT+01:00 David Cimbůrek <david.cimburek@gmail.com>:
> >> > No one is interested? I'd like to get this patch to kernel to fix the
> >> > issue. Can someone here do it please?
> >> >
> >> >
> >> > 2014-12-20 14:36 GMT+01:00 David Cimbůrek <david.cimburek@gmail.com>:
> >> >> Hi,
> >> >>
> >> >> with kernel 3.17 remote control for Pinnacle 73e (ID 2304:0237
> >> >> Pinnacle Systems, Inc. PCTV 73e [DiBcom DiB7000PC]) does not work
> >> >> anymore.
> >> >>
> >> >> I checked the changes and found out the problem in commit
> >> >> af3a4a9bbeb00df3e42e77240b4cdac5479812f9.
> >> >>
> >> >> In dib0700_core.c in struct dib0700_rc_response the following union:
> >> >>
> >> >> union {
> >> >>     u16 system16;
> >> >>     struct {
> >> >>         u8 not_system;
> >> >>         u8 system;
> >> >>     };
> >> >> };
> >> >>
> >> >> has been replaced by simple variables:
> >> >>
> >> >> u8 system;
> >> >> u8 not_system;
> >> >>
> >> >> But these variables are in reverse order! When I switch the order
> >> >> back, the remote works fine again! Here is the patch:
> >> >>
> >> >>
> >> >> --- a/drivers/media/usb/dvb-usr/dib0700_core.c    2014-12-20
> >> >> 14:27:15.000000000 +0100
> >> >> +++ b/drivers/media/usb/dvb-usr/dib0700_core.c    2014-12-20
> >> >> 14:27:36.000000000 +0100
> >> >> @@ -658,8 +658,8 @@
> >> >>  struct dib0700_rc_response {
> >> >>      u8 report_id;
> >> >>      u8 data_state;
> >> >> -    u8 system;
> >> >>      u8 not_system;
> >> >> +    u8 system;
> >> >>      u8 data;
> >> >>      u8 not_data;
> >> >>  };
> >> >>
> >> >>
> >> >> Regards,
> >> >> David
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
