Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23023 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755848Ab0EABIW (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Apr 2010 21:08:22 -0400
Message-ID: <4BDB7EFA.1020802@redhat.com>
Date: Fri, 30 Apr 2010 22:08:10 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
CC: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [ANNOUNCEMENT] Media controller tree updated
References: <201004292307.04385.laurent.pinchart@ideasonboard.com>
In-Reply-To: <201004292307.04385.laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent,

Laurent Pinchart wrote:
> Hi everybody,
> 
> The next version of the media controller patches is available in git at
> 
> http://git.linuxtv.org/pinchartl/v4l-dvb-media.git
> 
> To avoid putting too much pressure on the linuxtv.org git server, please make 
> sure you reference an existing mainline Linux git tree when cloning v4l-dvb-
> media (see the --reference option to git-clone).

I've made a small script that added the proper instructions to the existing
clones of the kernel tree. Please check if it is ok. 

The script is not automatic. When I have some time, I'll integrate it with some 
tool to run it automatically after a new tree is added there, but, for now, I 
need to run it after I notice that somebody created a new tree. The script has 
a basic test to discover that the tree is based on Kernel tree: it checks if a 
"v2.6.32" tag exist at the new tree (ok, I confess: I was very lazy when I wrote 
the script... it works with the current trees, but we need a more reliable way, 
if we want to run automatically).


Cheers,
Mauro
