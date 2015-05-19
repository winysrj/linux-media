Return-path: <linux-media-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49674 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842AbbESRiP (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2015 13:38:15 -0400
Date: Tue, 19 May 2015 20:36:44 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Antti Palosaari <crope@iki.fi>
Cc: Michael =?iso-8859-1?Q?B=FCsch?= <m@bues.ch>,
	Federico Simoncelli <fsimonce@redhat.com>,
	Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
	Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Ondrej Zary <linux@rainbow-software.org>,
	Ramakrishnan Muthukrishnan <ramakrmu@cisco.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Takashi Iwai <tiwai@suse.de>,
	Amber Thrall <amber.rose.thrall@gmail.com>,
	James Harper <james.harper@ejbdigital.com.au>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 2/2] drivers: Simplify the return code
Message-ID: <20150519173644.GP22558@mwanda>
References: <0fee1624f3df1827cb6d0154253f9c45793bf3e1.1432033220.git.mchehab@osg.samsung.com>
 <0fee1624f3df1827cb6d0154253f9c45793bf3e1.1432033220.git.mchehab@osg.samsung.com>
 <a24b23db60ffee5cb32403d7c8cacd25b13f4510.1432033220.git.mchehab@osg.samsung.com>
 <577085828.1080862.1432037155994.JavaMail.zimbra@redhat.com>
 <20150519141731.78744f2f@wiggum>
 <555B5E32.9060301@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <555B5E32.9060301@iki.fi>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, May 19, 2015 at 07:00:50PM +0300, Antti Palosaari wrote:
> I am also against that kind of simplifications. Even it reduces line
> or two, it makes code more inconsistent, which means you have to
> make extra thinking when reading that code. I prefer similar
> repeating patterns as much as possible.
> 
> This is how I do it usually, even there is that extra last goto.
> 
> 	ret = write_reg();
> 	if (ret)
> 		goto err;
> 
> 	ret = write_reg();
> 	if (ret)
> 		goto err;
> err:
> 	return ret;
> };
> 

I don't care too much about the original patch one way or the other.
The new code is more fashionable and fewer lines.

But these sorts of do-nothing returns are a blight.

They are misleading.  You expect goto err to do something.  You wander
what it is.  The name tells you nothing.  So you have to scroll down.
Oh crap, it's just a @#$@$@#$ waste of time do-nothing goto.  It's the
travel through a door problem, you have completely forgotten what you
are doing.

http://www.scientificamerican.com/article/why-walking-through-doorway-makes-you-forget/


And also they are a total waste of time if you care about preventing
bugs.

Some people complain about "hidden return statements" but that is only
an issue if you don't have syntax highlighting.  If you look through the
git logs it is full of places like 95f38411df055a0e ('netns: use a
spin_lock to protect nsid management') where the other coder had gotos
highlighted in the same color as regular code.  If you actually measure
how common return with lock held bugs are the goto err and the direct
return style code have equal amount of bugs.  (I have looked at this but
only briefly, so it would be interesting to see a thourough scientific
paper on it).

Also the goto err style code introduces a new class of "forgot to set
the error code" bugs which are not there in direct return code.

regards,
dan carpenter

