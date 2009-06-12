Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:41275 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754205AbZFLP6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 12 Jun 2009 11:58:12 -0400
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: David Brownell <david-b@pacbell.net>
CC: "davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Muralidharan Karicheri <a0868495@dal.design.ti.com>
Date: Fri, 12 Jun 2009 10:58:04 -0500
Subject: RE: [PATCH 0/10 - v2] ARM: DaVinci: Video: DM355/DM6446 VPFE
 Capture driver
Message-ID: <A69FA2915331DC488A831521EAE36FE40139A09633@dlee06.ent.ti.com>
References: <1244739649-27466-1-git-send-email-m-karicheri2@ti.com>
 <200906111324.24438.david-b@pacbell.net>
In-Reply-To: <200906111324.24438.david-b@pacbell.net>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



>>
>> This is the version v2 of the patch series. This is the reworked
>> version of the driver based on comments received against the last
>> version of the patch.
>
>I'll be glad to see this get to mainline ... it's seeming closer
>and closer!
>
>What's the merge plan though?  I had hopes for 2.6.31.real-soon
>but several of the later patches comment
>
Not sure if it can go in 2.6.31, but this has less comments to 
address then I can send a updated version next week. 2.6.32 is
the targeted release.
>  > Applies to Davinci GIT Tree
>
>which implies "not -next".  DM355 patches are in the "-next" tree.
>
>Is this just an oversight (tracking -next can be a PITA!) or is
>there some other dependency?
>
One dependency is the tvp514x sub device patch migration patch from Vaibhav. This is put for review, but couldn't see any comments.

I have split the patches such that v4l2 part can applies independently followed by platform part. All of the platform part has "Applies to Davinci GIT tree" in the patch description and v4l2 part has "Applies to v4l-dvb". The v4l2 part can go with out the platform changes, but platform part is dependent on the v4l2 part.

I am not sure if I have answered your question.
>-
>

