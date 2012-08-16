Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout3.w1.samsung.com ([210.118.77.13]:21791 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175Ab2HPJYL (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 16 Aug 2012 05:24:11 -0400
Received: from eusync3.samsung.com (mailout3.w1.samsung.com [210.118.77.13])
 by mailout3.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0M8U0055RCT6OY40@mailout3.w1.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Aug 2012 10:24:42 +0100 (BST)
Received: from [106.116.147.32] by eusync3.samsung.com
 (Oracle Communications Messaging Server 7u4-23.01(7.0.4.23.0) 64bit (built Aug
 10 2011)) with ESMTPA id <0M8U00D70CS80I00@eusync3.samsung.com> for
 linux-media@vger.kernel.org; Thu, 16 Aug 2012 10:24:09 +0100 (BST)
Message-id: <502CBC37.1010800@samsung.com>
Date: Thu, 16 Aug 2012 11:24:07 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
MIME-version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCE] tree renaming patches part 1 applied
References: <502A3DAF.6080301@redhat.com>
In-reply-to: <502A3DAF.6080301@redhat.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mauro,

On 08/14/2012 01:59 PM, Mauro Carvalho Chehab wrote:
> Anyway, in order to help people that might still have patches against
> the old structure, I created a small script and added them at the
> media_build tree:
> 	http://git.linuxtv.org/media_build.git/blob/HEAD:/devel_scripts/rename_patch.sh
> 
> (in fact, I created an script that auto-generated it ;) )
> 
> To use it, all you need to do is:
> 
> 	$ ./rename_patch.sh your_patch
> 
> As usual, if you want to change several patches, you could do:
> 	$ git format_patch some_reference_cs
> 
> and apply the rename_patch.sh to the generated 0*.patch files, like
> 	$ for i in 0*.patch; do ./rename_patch.sh $i; done
> 
> More details about that are at the readme file:
> 	http://git.linuxtv.org/media_build.git/blob/HEAD:/devel_scripts/README

Thanks for preparing this little helper script! It's helpful since I have
quite a few pending patches, and it also saves time when porting patches
from older kernel trees.

--
Regards,
Sylwester
