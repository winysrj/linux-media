Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:41558 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750717AbcBYVs7 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 25 Feb 2016 16:48:59 -0500
Date: Thu, 25 Feb 2016 23:48:22 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	linux-media@vger.kernel.org, hverkuil@xs4all.nl
Subject: Re: [PATCH v5 4/4] media-ctl: List supported media bus formats
Message-ID: <20160225214822.GE11084@valkosipuli.retiisi.org.uk>
References: <1456331128-7036-1-git-send-email-sakari.ailus@linux.intel.com>
 <1456331128-7036-5-git-send-email-sakari.ailus@linux.intel.com>
 <7141573.SjGf7uf7rF@avalon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7141573.SjGf7uf7rF@avalon>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Laurent and Hans,

On Thu, Feb 25, 2016 at 11:38:02PM +0200, Laurent Pinchart wrote:
...
> > @@ -48,6 +50,7 @@ static void usage(const char *argv0)
> >  	printf("-h, --help		Show verbose help and exit\n");
> >  	printf("-i, --interactive	Modify links interactively\n");
> >  	printf("-l, --links links	Comma-separated list of link descriptors to
> > setup\n");
> > +	printf("    --known-mbus-fmts	List known media bus formats and their
> > numeric values\n");
> 
> I still prefer help topics :-( The rest looks good to me, so
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> 
> but if we can convince Hans about --help= please use that :-)

Hans: would you be even slightly convincible? GCC, for instance, does that
as well, and I believe it's not the only one:


23:46:52 lanttu sailus [/tmp]gcc --help|grep help
  --help                   Display this information
  --target-help            Display target specific command line options
  --help={common|optimizers|params|target|warnings|[^]{joined|separate|undocumented}}[,...]
  (Use '-v --help' to display command line options of sub-processes)


-- 
Cheers,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
