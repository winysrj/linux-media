Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:48042
        "EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753072AbcIHLkZ (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Thu, 8 Sep 2016 07:40:25 -0400
Date: Thu, 8 Sep 2016 08:40:18 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Markus Heiser <markus.heiser@darmarit.de>,
        Jonathan Corbet <corbet@lwn.net>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] docs-rst: ignore arguments on macro definitions
Message-ID: <20160908084018.492d59bf@vento.lan>
In-Reply-To: <BBC1BC77-BCF1-453C-B85D-9758C4C433A6@darmarit.de>
References: <e4955d6ed9b730f544fe40b0344c4451dd415cda.1472476362.git.mchehab@s-opensource.com>
        <BBC1BC77-BCF1-453C-B85D-9758C4C433A6@darmarit.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Jon/Markus,

Em Mon, 29 Aug 2016 16:12:39 +0200
Markus Heiser <markus.heiser@darmarit.de> escreveu:

> Am 29.08.2016 um 15:13 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
> 
> > A macro definition is mapped via .. c:function:: at the
> > ReST markup when using the following kernel-doc tag:
> > 
> > 	/**
> > 	 * DMX_FE_ENTRY - Casts elements in the list of registered
> > 	 *               front-ends from the generic type struct list_head
> > 	 *               to the type * struct dmx_frontend
> > 	 *
> > 	 * @list: list of struct dmx_frontend
> > 	 */
> > 	 #define DMX_FE_ENTRY(list) \
> > 	        list_entry(list, struct dmx_frontend, connectivity_list)
> > 
> > However, unlike a function description, the arguments of a macro
> > doesn't contain the data type.
> > 
> > This causes warnings when enabling Sphinx on nitkpick mode,
> > like this one:
> > 	./drivers/media/dvb-core/demux.h:358: WARNING: c:type reference target not found: list  
> 
> I think this is a drawback of sphinx's C-domain, using function
> definition for macros also. From the function documentation
> 
>  """This is also used to describe function-like preprocessor
>     macros. The names of the arguments should be given so
>     they may be used in the description."""
> 
> I think about to fix the nitpick message for macros (aka function
> directive) in the C-domain extension (we already have).
> 
> But for this, I need a rule to distinguish between macros
> and functions ... is the uppercase of the macro name a good
> rule to suppress the nitpick message? Any other suggestions?

What's the status of the C domain patches meant to fix this issue?

I managed to fix most warnings on media documents on nitpick mode.
With this patch applied, there are only 21 warnings (and all are
due to the lack of function or struct documentation). I'm about
to patchbomb such fixup series.

Yet, without  this patch, and latest docs-next, there are 20 extra
bogus warnings, due to function parameters:

 ./drivers/media/dvb-core/dvb_ringbuffer.h:121: WARNING: c:type reference target not found: rbuf
 ./drivers/media/dvb-core/dvb_ringbuffer.h:121: WARNING: c:type reference target not found: offs
 ./drivers/media/dvb-core/dvb_ringbuffer.h:130: WARNING: c:type reference target not found: rbuf
 ./drivers/media/dvb-core/dvb_ringbuffer.h:130: WARNING: c:type reference target not found: num
 ./drivers/media/dvb-core/dvb_ringbuffer.h:173: WARNING: c:type reference target not found: rbuf
 ./drivers/media/dvb-core/dvb_ringbuffer.h:173: WARNING: c:type reference target not found: byte
 ./drivers/media/dvb-core/demux.h:358: WARNING: c:type reference target not found: list
 ./include/media/media-device.h:263: WARNING: c:type reference target not found: mdev
 ./include/media/media-device.h:495: WARNING: c:type reference target not found: mdev
 ./include/media/media-device.h:495: WARNING: c:type reference target not found: udev
 ./include/media/media-device.h:495: WARNING: c:type reference target not found: name
 ./include/media/media-entity.h:527: WARNING: c:type reference target not found: gobj
 ./include/media/media-entity.h:536: WARNING: c:type reference target not found: gobj
 ./include/media/media-entity.h:545: WARNING: c:type reference target not found: gobj
 ./include/media/media-entity.h:554: WARNING: c:type reference target not found: gobj
 ./include/media/media-entity.h:563: WARNING: c:type reference target not found: intf
 ./include/media/media-entity.h:1041: WARNING: c:type reference target not found: entity
 ./include/media/media-entity.h:1041: WARNING: c:type reference target not found: operation
 ./include/media/v4l2-ctrls.h:397: WARNING: c:type reference target not found: hdl
 ./include/media/v4l2-ctrls.h:397: WARNING: c:type reference target not found: nr_of_controls_hint

So, it would be great if we could either merge this patch or the ones that
Markus did (assuming they're ready for merge).

Regards,
Mauro

> 
> -- Markus --
> 
> > 
> > That happens because kernel-doc output for the above is:
> > 
> > 	.. c:function:: DMX_FE_ENTRY ( list)
> > 
> > 	   Casts elements in the list of registered front-ends from the generic type struct list_head to the type * struct dmx_frontend
> > 
> > 	**Parameters**
> > 
> > 	``list``
> > 	  list of struct dmx_frontend
> > 
> > As the type is blank, Sphinx would think that ``list`` is a type,
> > and will try to add a cross reference for it, using their internal
> > representation for c:type:`list`.
> > 
> > However, ``list`` is not a type. So, that would cause either the
> > above warning, or if a ``list`` type exists, it would create
> > a reference to the wrong place at the doc.
> > 
> > To avoid that, let's ommit macro arguments from c:function::
> > declaration. As each argument will appear below the Parameters,
> > the type of the argument can be described there, if needed.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> > ---
> > 
> > v3: version 2 patch caused a regression when handling function arguments,
> > because the counter were not incremented on all cases. Fix it.
> > 
> > scripts/kernel-doc | 5 +++--
> > 1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> > index d225e178aa1b..bac0af4fc659 100755
> > --- a/scripts/kernel-doc
> > +++ b/scripts/kernel-doc
> > @@ -1846,14 +1846,15 @@ sub output_function_rst(%) {
> > 	if ($count ne 0) {
> > 	    print ", ";
> > 	}
> > -	$count++;
> > 	$type = $args{'parametertypes'}{$parameter};
> > 
> > 	if ($type =~ m/([^\(]*\(\*)\s*\)\s*\(([^\)]*)\)/) {
> > 	    # pointer-to-function
> > 	    print $1 . $parameter . ") (" . $2;
> > -	} else {
> > +	    $count++;
> > +	} elsif ($type ne "") {
> > 	    print $type . " " . $parameter;
> > +	    $count++;
> > 	}
> >    }
> >    print ")\n\n";
> > -- 
> > 2.7.4
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-media" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html  
> 



Thanks,
Mauro
