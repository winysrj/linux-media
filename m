Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:42216 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443Ab3IKNan (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Sep 2013 09:30:43 -0400
Received: by mail-lb0-f181.google.com with SMTP id u14so7305161lbd.26
        for <linux-media@vger.kernel.org>; Wed, 11 Sep 2013 06:30:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CALuNSF4znGu+NdsZs3eb0A5vqgyHNC13f8qXunNE2tXVxC=UTg@mail.gmail.com>
References: <CALuNSF4znGu+NdsZs3eb0A5vqgyHNC13f8qXunNE2tXVxC=UTg@mail.gmail.com>
Date: Wed, 11 Sep 2013 19:00:42 +0530
Message-ID: <CAHFNz9Kdmzj3uTP=n7nqBgZdH6MtUPeg1bBWA3=SLmC+-9NCfw@mail.gmail.com>
Subject: Re: Correct scan file format?
From: Manu Abraham <abraham.manu@gmail.com>
To: Simon Liddicott <simon@liddicott.com>
Cc: linux-media <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 11, 2013 at 6:19 PM, Simon Liddicott <simon@liddicott.com> wrote:
> What form should T2 multiplexes take in the DVB scan files?
>
> In the uk-CrystalPalace scan file
> <http://git.linuxtv.org/dtv-scan-tables.git/blob/HEAD:/dvb-t/uk-CrystalPalace>
> the PLP_ID and System_ID are included before the frequency but in
> ro-Krasnador scan file
> <http://git.linuxtv.org/dtv-scan-tables.git/blob/HEAD:/dvb-t/ru-Krasnodar>
> the PLP_ID is included at the end of the line and it has no System_ID.



PLP_ID should be the very last entity to preserve compatibility.



> I don't have a T2 tuner to test. Is a PLP_ID required in the scan file
> as in the UK we only have one?
>



If you have only a single stream, it wouldn't make any difference if you
have a PLP_ID or not.



> I presume the System_ID has been included in the Crystal Palace file
> because it was known by w_scan, but is it required for T2?
>


System ID is used for decryption with Conditional Access. If you don't
need to use a CA module, then you can ignore it.


Regards,

Manu
