Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:36657
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752781AbcHAL0G (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Aug 2016 07:26:06 -0400
Date: Mon, 1 Aug 2016 08:19:14 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Michal Marek <mmarek@suse.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Ben Hutchings <ben@decadent.org.uk>,
	Daniel Baluta <daniel.baluta@intel.com>,
	Danilo Cesar Lemes de Paula <danilo.cesar@collabora.co.uk>,
	linux-doc@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] doc-rst: Remove the media docbook
Message-ID: <20160801081914.4c01ddae@recife.lan>
In-Reply-To: <87invkvmk3.fsf@intel.com>
References: <4fb2b55b3d3215b2f6c649417d749f8f27b2df77.1469611833.git.mchehab@s-opensource.com>
	<87invkvmk3.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jani,

Em Mon, 01 Aug 2016 12:57:32 +0300
Jani Nikula <jani.nikula@intel.com> escreveu:

> On Wed, 27 Jul 2016, Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
> > Now that all media documentation was converted to Sphinx, we
> > should get rid of the old DocBook one, as we don't want people
> > to submit patches against the old stuff.  
> 
> Mauro, judging from the discussions we've had over the past six months,
> I never would have guessed media docs would be among the first docbooks
> converted. Fantastic job!

Thanks!

Yeah, I opted to do the full conversion while all the discussions are
fresh, as I found easier to remember what were the major issues and check
if they were properly addressed on the conversion.

Thanks for your and Markus support helping to address the issues!

My general impression is that it is now a way easier to maintain the
media documentation and make it more consistent than with DocBook. 

Thanks,
Mauro
