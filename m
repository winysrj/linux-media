Return-path: <mchehab@gaivota>
Received: from cmsout01.mbox.net ([165.212.64.31]:36058 "EHLO
	cmsout01.mbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab1EIUke (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 9 May 2011 16:40:34 -0400
Message-ID: <4DC85115.6020604@usa.net>
Date: Mon, 09 May 2011 22:39:49 +0200
From: Issa Gorissen <flop.m@usa.net>
MIME-Version: 1.0
To: =?ISO-8859-1?Q?=22S=E9bastien_RAILLARD_=28COEXSI=29=22?=
	<sr@coexsi.fr>
CC: 'Ralph Metzler' <rjkm@metzlerbros.de>,
	'Linux Media Mailing List' <linux-media@vger.kernel.org>,
	'Oliver Endriss' <o.endriss@gmx.de>,
	'Martin Vidovic' <xtronom@gmail.com>
Subject: Re: DVB nGene CI : TS Discontinuities issues
References: <004f01cc0981$2d371ec0$87a55c40$@coexsi.fr>	<4DC5622A.9040403@usa.net> <19909.47855.351946.831380@morden.metzler> <4DC73854.7090104@usa.net> <000901cc0e17$65fc4510$31f4cf30$@coexsi.fr>
In-Reply-To: <000901cc0e17$65fc4510$31f4cf30$@coexsi.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
List-ID: <linux-media.vger.kernel.org>
Sender: Mauro Carvalho Chehab <mchehab@gaivota>

On 09/05/11 09:04, Sébastien RAILLARD (COEXSI) wrote:
>> I don't know if CAT needs to be in the stream passed through sec0 as
>> Sebastien mentioned, so I modified gnutv to add it to dvr.
>>
> Yes, the CAT table is mandatory, it must be sent to the CAM, as well as :
> * the EMM PID referenced in the CAT
> * all the private descriptors (binary blobs) in the PMT and, of course
> * the ECM PID referenced in the PMT
>
> Of course, the CAM must be initialized, all the necessary CAM resources must
> be initialized and a CA_PMT object must be sent through the CAM command
> channel to ask for unscrambling of needed channels.
>
> That why it's better to send directly the raw TS output of the demodulator
> directly in the CAM.
> And then doing the demux filtering stuff on the TS stream coming from the
> CAM (once unscrambled).

Thx Sebastien,

Will check this out with gnutv and report.

I think gnutv does all the init stuff you mentioned about the CAM. I
will check for the possibly missing PSI packets gnutv might exclude.

--
Issa
