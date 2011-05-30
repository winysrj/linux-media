Return-path: <mchehab@pedra>
Received: from nm26-vm0.bullet.mail.sp2.yahoo.com ([98.139.91.230]:42651 "HELO
	nm26-vm0.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751229Ab1E3CNL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Sun, 29 May 2011 22:13:11 -0400
Message-ID: <290776.52536.qm@web112005.mail.gq1.yahoo.com>
Date: Sun, 29 May 2011 19:13:10 -0700 (PDT)
From: Chris Rodley <carlighting@yahoo.co.nz>
Subject: Re: [beagleboard] [PATCH] Second RFC version of mt9p031 sensor with power managament.
To: g.liakhovetski@gmx.de, javier.martin@vista-silicon.com
Cc: koen@beagleboard.org, beagleboard@googlegroups.com,
	linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On 29/05/11 03:04, Guennadi Liakhovetski wrote:
> On Sat, 28 May 2011, Guennadi Liakhovetski wrote:
>
>> Hi Javier
>>
>> On Thu, 26 May 2011, javier Martin wrote:
>>
>>> I use a patched version of yavta and Mplayer to see video
>>> (http://download.open-technology.de/BeagleBoard_xM-MT9P031/)
>>
>> Are you really using those versions and patches, as described in 
>> BBxM-MT9P031.txt? I don't think those versions still work with 2.6.39, 
>> they don't even compile for me. Whereas if I take current HEAD, it builds 
>> and media-ctl seems to run error-free, but yavta produces no output.
>
> Ok, sorry for the noise. It works with current media-ctl with no patches, 
> so, we better don't try to confuse our users / testers:)
>
> Thanks
> Guennadi

Hi,

Still no luck getting the v3 patch working.
I did go back and re-test the first v1 patch that Javier released.
This works fine with the same version of media-ctl and yavta.
So it isn't either of those programs that is causing the problem.

Must be something else.

Will wait and see how Koen goes.

Cheers,
Chris

