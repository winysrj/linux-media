Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:39757
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754929AbdERKAe (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 18 May 2017 06:00:34 -0400
Date: Thu, 18 May 2017 07:00:28 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, devel@driverdev.osuosl.org
Subject: Re: [PATCH] [media] atomisp: don't treat warnings as errors
Message-ID: <20170518070028.2d41763d@vento.lan>
In-Reply-To: <CAK8P3a0Fw30dmUGY=piihxk_EwsxEfD9pJ+DD+WE537L9Tkuow@mail.gmail.com>
References: <dd8245f445f5e751b38126140b6ba1723f06c60b.1495097103.git.mchehab@s-opensource.com>
        <CAK8P3a0Fw30dmUGY=piihxk_EwsxEfD9pJ+DD+WE537L9Tkuow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 18 May 2017 11:05:24 +0200
Arnd Bergmann <arnd@arndb.de> escreveu:

> On Thu, May 18, 2017 at 10:45 AM, Mauro Carvalho Chehab
> <mchehab@s-opensource.com> wrote:
> > Several atomisp files use:
> >          ccflags-y += -Werror
> >
> > As, on media, our usual procedure is to use W=1, and atomisp
> > has *a lot* of warnings with such flag enabled,like:
> >
> > ./drivers/staging/media/atomisp/pci/atomisp2/css2400/hive_isp_css_common/host/system_local.h:62:26: warning: 'DDR_BASE' defined but not used [-Wunused-const-variable=]
> >
> > At the end, it causes our build to fail, impacting our workflow.
> >
> > So, remove this crap. If one wants to force -Werror, he
> > can still build with it enabled by passing a parameter to
> > make.
> >
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>  
> 
> Good idea.
> 
> On a related note, I have some plans for more fine-grained and more consisten
> control of warning and error messages. The same way we already use W=1
> or W=12, I would like to allow E=0 E=01 etc to turn warnings of a particular
> W= level into errors, and possibly even allow this on a per-file or
> per-directory

That sounds very promising!

> basis. It depends on some infrastructure to replace scripts/Makefile.extrawarn
> with a include/linux/compiler-warnings.h using _Pragma("GCC diagnostic ..."),
> but that infrastructure has other benefits as well.
> 
> Would you be interested in having the equivalent of W=1 (some extra warnings)
> or E=0 (default warnings become errors) enabled for drivers/media if we had
> a good way of doing that?

Yeah, sure!

Thanks,
Mauro
