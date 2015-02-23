Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpq1.tb.mail.iss.as9143.net ([212.54.42.164]:33190 "EHLO
	smtpq1.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751249AbbBWV3K (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 16:29:10 -0500
Message-ID: <54EB9B9F.5000400@grumpydevil.homelinux.org>
Date: Mon, 23 Feb 2015 22:29:03 +0100
From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
MIME-Version: 1.0
To: =?UTF-8?B?SG9uemEgUGV0cm91xaE=?= <jpetrous@gmail.com>
CC: =?UTF-8?B?VHljaG8gTMO8cnNlbg==?= <tycholursen@gmail.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: DVB Simulcrypt
References: <54E8F8F4.1010601@grumpydevil.homelinux.org>	<54E9F59A.4070407@grumpydevil.homelinux.org>	<CAJbz7-2efvftG4=UAphyLFjjuFpLZQKCFDzqXrwb-mfDg4A7SQ@mail.gmail.com>	<54EB016D.8040105@grumpydevil.homelinux.org>	<CAJbz7-0U-s543mQ+a+sNt1V2m8T23X=ST5VYJ7LF0tk-n_yd8g@mail.gmail.com>	<54EB2099.5040103@grumpydevil.homelinux.org>	<54EB3784.4090908@gmail.com>	<54EB4C85.1050003@grumpydevil.homelinux.org> <CAJbz7-2hQo-jtJCqx1OEuTOxtzVYNVR+e7SvssFJ5YY2ZU=YQw@mail.gmail.com>
In-Reply-To: <CAJbz7-2hQo-jtJCqx1OEuTOxtzVYNVR+e7SvssFJ5YY2ZU=YQw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23-02-15 20:56, Honza Petrouš wrote:
> 2015-02-23 16:51 GMT+01:00 Rudy Zijlstra <rudy@grumpydevil.homelinux.org>:
>> And yes, my CAM's are for Irdeto and do not support Nagra. To my 
>> knowledge no valid Nagra CAM do exist for DVB-C 
> I'm a bit fossil regarding current status of CA in DVB but anyway I can say
> I know that some years ago existed CI-CAM modules for Nagra, it was
> in time of so-called Nagra2 introduction on Hispasat ;)
>
> Dunno how is the current situation.
>
> An second - it has no difference if it is for sattelite or cable variant
> of DVB. The CI-CAM standard is the same. The only problem
> can be if support for particular provider is "baked" inside (meaning
> only particular auth data are inserted).
>
>
The point is that although from standard point of view you are right, no 
cable operator has ever wanted to support Nagra CAM. As a result the 
needed CAM authorization is not present.

CI+ is a different story. Would need to check if CI+ is available in PC 
card form now. Kind of doubt that though. Do not expect Nagra wil 
support such development (refuse to validate).

Cheers


Rudy
