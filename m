Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailex.mailcore.me ([94.136.40.62]:53794 "EHLO
	mailex.mailcore.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465AbaDPQ4u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Apr 2014 12:56:50 -0400
Message-ID: <534EB64A.5050700@sca-uk.com>
Date: Wed, 16 Apr 2014 17:56:42 +0100
From: Steve Cookson <it@sca-uk.com>
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>,
	Steven Toth <stoth@kernellabs.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Hauppauge ImpactVCB-e 01385
References: <534675E1.6050408@sca-uk.com> <5347B132.6040206@sca-uk.com> <5347B9A3.2050301@xs4all.nl> <5347BDDE.6080208@sca-uk.com> <5347C57B.7000207@xs4all.nl> <5347DD94.1070000@sca-uk.com> <5347E2AF.6030205@xs4all.nl> <5347EB5D.2020408@sca-uk.com> <5347EC3D.7040107@xs4all.nl> <5348392E.40808@sca-uk.com> <534BEA8A.2040604@xs4all.nl> <534D6241.5060903@sca-uk.com> <534D68C2.6050902@xs4all.nl> <534D7E24.4010602@sca-uk.com> <534E5438.3030404@xs4all.nl> <534E8225.6090804@sca-uk.com> <534E839C.6060203@xs4all.nl>
In-Reply-To: <534E839C.6060203@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Guys,
On 16/04/14 14:20, Hans Verkuil wrote:
 >> However looking at the tree structure I have to say I don't understand
 >> > it.  Firstly there seem to be two equivalent branches in 
/lib/modules/:
 >> >
 >> > 1) drivers/linux/drivers/misc/altera-stapl/
 >> >
 >> > and
 >> >
 >> > 2) drivers/misc/altera-stapl/
 >> >
 >> > Before I do the patch and build, altera-stapl.ko is in 2) but the 
make
 >> > install puts the new version in 1).
 > Weird. It looks like media_build misinstalls this. If altera-stapl is in
 > the wrong place, then I suspect the other modules are also in the wrong
 > place and thus duplicated, which will cause all the things you see below.
 >
 > Which distro are you using?
 >
 > Anyway, I would recommend that you make a safety copy of your modules
 > first (just in case  ), and then move all the newly install modules
 > to the right place.

Well after much soul-searching about how to find out how many files were 
in the wrong place, it turns out it was JUST one: altera-stapl.ko

It was the only one in drivers/linux/drivers/misc/altera-stapl/. When I 
moved it everything fell into place the card was detected.

So this is the solution to issue one.

My distribution is Debian (Kubuntu 13.10) and this appears to be the 
only file that goes in the wrong place.  How do I log this as a bug?

I set up a video feed and the video was detected.

Results follow in next email.

Regards

Steve.
