Return-path: <linux-media-owner@vger.kernel.org>
Received: from lists.s-osg.org ([54.187.51.154]:34090 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757804AbbKSLxG (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 19 Nov 2015 06:53:06 -0500
Date: Thu, 19 Nov 2015 09:53:00 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [PATCH] DocBook: only copy stuff to media_api if media xml is
 generated
Message-ID: <20151119095300.7a296d83@recife.lan>
In-Reply-To: <20151119101943.GB17128@valkosipuli.retiisi.org.uk>
References: <e99ac34ef0b822ac3007b00a499a67eb1af36d9a.1447926299.git.mchehab@osg.samsung.com>
	<20151119101943.GB17128@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Thu, 19 Nov 2015 12:19:43 +0200
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> Hi Mauro,
> 
> On Thu, Nov 19, 2015 at 07:45:13AM -0200, Mauro Carvalho Chehab wrote:
> > It is possible to use:
> > 	make DOCBOOKS=device-drivers.xml htmldocs
> > 
> > To produce just a few docbooks. In such case, the media docs
> > won't be built, causing the makefile target to return an error.
> > 
> > While this is ok for human eyes, if the above is used on an script,
> > it would cause troubles.
> > 
> > Fix it by only creating/filling the media_api directory if the
> > media_api.xml is found at DOCBOOKS.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> > ---
> >  Documentation/DocBook/media/Makefile | 6 ++++--
> >  1 file changed, 4 insertions(+), 2 deletions(-)
> > 
> > diff --git a/Documentation/DocBook/media/Makefile b/Documentation/DocBook/media/Makefile
> > index 02848146fc3a..2840ff483d5a 100644
> > --- a/Documentation/DocBook/media/Makefile
> > +++ b/Documentation/DocBook/media/Makefile
> > @@ -199,8 +199,10 @@ DVB_DOCUMENTED = \
> >  #
> >  
> >  install_media_images = \
> > -	$(Q)-mkdir -p $(MEDIA_OBJ_DIR)/media_api; \
> > -	cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/*.svg $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api
> > +	$(Q)if [ "x$(findstring media_api.xml,$(DOCBOOKS))" != "x" ]; then \
> > +		mkdir -p $(MEDIA_OBJ_DIR)/media_api; \
> > +		cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/*.svg $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api; \
> > +	fi
> >  
> >  $(MEDIA_OBJ_DIR)/%: $(MEDIA_SRC_DIR)/%.b64
> >  	$(Q)base64 -d $< >$@
> 
> I'd still copy the files even if the directory was there. It's entirely
> possible that new files appeared between the make runs, or that the existing
> files changed. cp will just overwrite the targets in that case.
> 
> Albeit one still has to issue "make cleandocs" to get the DocBook rebuilt.
> Oh well... One thing at a time? :-)

I guess you misread the patch...

It unconditionally copy the files even if the media_api directory exists,
if make is called with:
	make htmldocs

or with:
	make DOCBOOKS=media_api.xml htmldocs

It will only suppress the copy and dir make if someone wants to build
some other html file, with something like:

	make DOCBOOKS=device-drivers.xml htmldocs

Please notice that I use internally a script that detects when a patch
is merged on my tree. In such case, it builds the Kernel and the
documentation, if it is affected, with this logic:

                        cat Documentation/DocBook/device-drivers.tmpl |perl -ne 'print "$1\n" if (m/^\!I(.*media.*)/)' >$TMPFILE
                        if [ "`git show $TAG|diffstat -p1 -l|grep -f $TMPFILE`" ]; then
                                rm $TMPFILE
				make DOCBOOKS=device-drivers.xml htmldocs 2>&1|grep /media/
                                if [ "$?" != "0" ]; then
                                        play ~/sounds/pipe.wav 2>/dev/null >/dev/null
                                fi
                        else
                            	rm $TMPFILE
                        fi

Without this patch, it beeps all the times it runs, because 
	cp $(OBJIMGFILES) $(MEDIA_SRC_DIR)/*.svg $(MEDIA_SRC_DIR)/v4l/*.svg $(MEDIA_OBJ_DIR)/media_api; 

will fail, as no OBJIMGFILES would be produced.

Regards,
Mauro
