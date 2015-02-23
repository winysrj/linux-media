Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpq1.tb.mail.iss.as9143.net ([212.54.42.164]:50067 "EHLO
	smtpq1.tb.mail.iss.as9143.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752136AbbBWKfE (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 23 Feb 2015 05:35:04 -0500
Message-ID: <54EB0250.1070802@grumpydevil.homelinux.org>
Date: Mon, 23 Feb 2015 11:34:56 +0100
From: Rudy Zijlstra <rudy@grumpydevil.homelinux.org>
MIME-Version: 1.0
To: =?windows-1252?Q?Honza_Petrou=9A?= <jpetrous@gmail.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: DVB Simulcrypt
References: <54E8F8F4.1010601@grumpydevil.homelinux.org>	<54E9F59A.4070407@grumpydevil.homelinux.org> <CAJbz7-2efvftG4=UAphyLFjjuFpLZQKCFDzqXrwb-mfDg4A7SQ@mail.gmail.com>
In-Reply-To: <CAJbz7-2efvftG4=UAphyLFjjuFpLZQKCFDzqXrwb-mfDg4A7SQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 23-02-15 08:44, Honza Petrouš wrote:
> Hi Rudy.
>
> 2015-02-22 16:28 GMT+01:00 Rudy Zijlstra 
> <rudy@grumpydevil.homelinux.org <mailto:rudy@grumpydevil.homelinux.org>>:
> >
> > Some more info
> >
> > On 21-02-15 22:30, Rudy Zijlstra wrote:
> >>
> >> Dears (Hans?)
> >>
> >> My setup, where the cable operator was using only irdeto, was 
> working good. Then the cable operator merged with another, and now the 
> networks are being merged. As a result, the encryption has moved from 
> irdeto only to simulcyrpt with Irdeto and Nagra.
> >>
> >> Current status:
> >> - when i put the CA card in a STB, it works
> >> - when trying to record an encrypted channel from PC, it no longer 
> works.
> >
> > Recording system has 3 tuners. All equal, all with same permissions 
> on the smartcard. On cards 0 and 2 does not work, but card 1 does 
> work, on all channels tested.
> >
>
> Does it mean that descrambling is not working for you? If so,
> how do you manage descrambling? By CI-CAM module
> or by some "softcam" like oscam?
>
> Or do you record ENCRYPTED stream and decrypt the recordings
> later on?

Each tuner has its own legal CI-CAM module. And yes, except for the 
second tuner descrambling no longer works

Cheers


Rudy
>
> /Honza
>
> >

