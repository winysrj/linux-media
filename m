Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.kapsi.fi ([217.30.184.167]:44817 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751160AbaKYQuQ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Nov 2014 11:50:16 -0500
Message-ID: <5474B343.1070600@iki.fi>
Date: Tue, 25 Nov 2014 18:50:11 +0200
From: Antti Palosaari <crope@iki.fi>
MIME-Version: 1.0
To: linux-media@vger.kernel.org,
	Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [git:media_tree/master] [media] em28xx: Add support for Terratec
 Cinergy T2 Stick HD
References: <E1XtHEF-0002RQ-0i@www.linuxtv.org>
In-Reply-To: <E1XtHEF-0002RQ-0i@www.linuxtv.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 11/25/2014 01:13 PM, Mauro Carvalho Chehab wrote:
> This is an automatic generated email to let you know that the following patch were queued at the
> http://git.linuxtv.org/media_tree.git tree:
>
> Subject: [media] em28xx: Add support for Terratec Cinergy T2 Stick HD
> Author:  Olli Salonen <olli.salonen@iki.fi>
> Date:    Mon Nov 24 03:57:34 2014 -0300
>
> Terratec Cinergy T2 Stick HD [eb1a:8179] is a USB DVB-T/T2/C tuner that
> contains following components:
>
> * Empia EM28178 USB bridge
> * Silicon Labs Si2168-A30 demodulator
> * Silicon Labs Si2146-A10 tuner
>
> I don't have the remote, so the RC_MAP is a best guess based on the pictures of
> the remote controllers and other supported Terratec devices with a similar
> remote.
>
> [Antti: Resolved conflict caused by Leadtek VC100 patch]
>
> Signed-off-by: Olli Salonen <olli.salonen@iki.fi>
> Signed-off-by: Antti Palosaari <crope@iki.fi>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>


Mauro, May I ask why you remove all the time my Reviewed-by tags? I have 
added it explicitly when I do careful review for the patch. I think it 
could be there even there is my Signed-off-by tag, which is there mainly 
because patch was submitted via my tree (patch's delivery path).

I cannot see any rule which says I cannot add both tags (especially 
because meaning of both tags is bit different):

Documentation/SubmittingPatches


regards
Antti

-- 
http://palosaari.fi/
