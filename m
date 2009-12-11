Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63192 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760725AbZLKCyh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Dec 2009 21:54:37 -0500
Received: by bwz27 with SMTP id 27so346679bwz.21
        for <linux-media@vger.kernel.org>; Thu, 10 Dec 2009 18:54:43 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <829197380912101749w5f1d1635gbdda2ac2fb980b8c@mail.gmail.com>
References: <44c6f3de0912041415r54d8ab6fq486f2a82edb91a68@mail.gmail.com>
	<829197380912041526r764a0deeyb64910a22e92d75d@mail.gmail.com>
	<829197380912072020s79199b84g20dbc341e4d231e1@mail.gmail.com>
	<44c6f3de0912101738h7f102929i54fbcceceb616edf@mail.gmail.com>
	<829197380912101749w5f1d1635gbdda2ac2fb980b8c@mail.gmail.com>
From: John S Gruber <johnsgruber@gmail.com>
Date: Thu, 10 Dec 2009 21:54:22 -0500
Message-ID: <44c6f3de0912101854t4fc4603dn1ec4afbb77362e42@mail.gmail.com>
Subject: Re: [PATCH] sound/usb: Relax urb data alignment restriciton for
	HVR-950Q only
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Dec 10, 2009 at 8:49 PM, Devin Heitmueller
<dheitmueller@kernellabs.com> wrote:
> Hello John,
>
> On Thu, Dec 10, 2009 at 8:38 PM, John S Gruber <johnsgruber@gmail.com> wrote:
>> I think you found something in the specification I haven't found. What did you
>> see that indicated how to deal with equipment misbehaving in this way?
>
> I'm referring to section 2.3.2.3 of "Universal Serial Bus Device Class
> Definition for Audio Data Formats"
>
>> I found the following list of USB ID's. Just double checking, but is
>> the 850 enough like the
>> 950 line for me to include it?
>>
>>        case 72000: /* WinTV-HVR950q (Retail, IR, ATSC/QAM */
>>        case 72001: /* WinTV-HVR950q (Retail, IR, ATSC/QAM and analog video */
>>        case 72211: /* WinTV-HVR950q (OEM, IR, ATSC/QAM and analog video */
>>        case 72221: /* WinTV-HVR950q (OEM, IR, ATSC/QAM and analog video */
>>        case 72231: /* WinTV-HVR950q (OEM, IR, ATSC/QAM and analog video */
>>        case 72241: /* WinTV-HVR950q (OEM, No IR, ATSC/QAM and analog video */
>>        case 72251: /* WinTV-HVR950q (Retail, IR, ATSC/QAM and analog video */
>> -->   case 72301: /* WinTV-HVR850 (Retail, IR, ATSC and analog video */
>>        case 72500: /* WinTV-HVR950q (OEM, No IR, ATSC/QAM */
>
> Yes, the HVR-850 should be included in the list.
>
>> I'd add that being the beginner at making kernel changes your review
>> is particularly
>> helpful to me (and to my confidence).
>
> You are likely to receive a more thorough/critical review when you
> send to the alsa-devel mailing list, as they have considerably more
> expertise in this area than I do.
>
> Devin
>
> --
> Devin J. Heitmueller - Kernel Labs
> http://www.kernellabs.com
>

I'll do that.
