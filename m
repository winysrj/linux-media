Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:40509 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751895AbcIVMfX (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 22 Sep 2016 08:35:23 -0400
Date: Thu, 22 Sep 2016 09:35:16 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Jonathan Corbet <corbet@lwn.net>,
        Jani Nikula <jani.nikula@intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-doc@vger.kernel.org Mailing List" <linux-doc@vger.kernel.org>
Subject: kernel-lintdoc parser - was: Re: [PATCH v2 0/3] doc-rst:c-domain:
 fix some issues in the c-domain
Message-ID: <20160922093516.3f28323e@vento.lan>
In-Reply-To: <20160922090850.56e3ebb1@vento.lan>
References: <1473232378-11869-1-git-send-email-markus.heiser@darmarit.de>
        <20160909090832.35c2d982@vento.lan>
        <73B0403A-272C-4058-A0D9-493C685EE332@darmarit.de>
        <1089B8C0-6296-4CC4-84B9-A1F62FA565AD@darmarit.de>
        <20160919120030.4e390e9a@vento.lan>
        <35B447A7-6C12-4560-8D06-110B8B33CB56@darmarit.de>
        <20160922090850.56e3ebb1@vento.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Markus,

Em Thu, 22 Sep 2016 09:08:50 -0300
Mauro Carvalho Chehab <mchehab@infradead.org> escreveu:

> Em Tue, 20 Sep 2016 20:56:35 +0200
> Markus Heiser <markus.heiser@darmarit.de> escreveu:
> 

> The new parser seems to have some bugs, like those:
> 
> $ kernel-lintdoc include/media/v4l2-ctrls.h
> include/media/v4l2-ctrls.h:106 :WARN: typedef of function pointer not marked as typdef, use: 'typedef v4l2_ctrl_notify_fnc' in the comment.
> ...
> include/media/v4l2-ctrls.h:605 :WARN: typedef of function pointer not marked as typdef, use: 'typedef v4l2_ctrl_filter' in the comment.
> ...
> include/media/v4l2-ctrls.h:809 [kernel-doc WARN] : can't understand function proto: 'const char * const *v4l2_ctrl_get_menu(u32 id);'
> ...

I ran the kernel-lintdoc with:
	for i in $(git grep kernel-doc Documentation/media/kapi/|cut -d: -f4); do kernel-lintdoc --sloppy $i; done

and I have a few comments:

1) instead of printing the full patch, it would be good to print the
relative patch, as this makes easier to paste the errors on e-mails
and on patches.

2) Parsing of embedded structs/unions

On some headers like dvb_frontend.h, we have unamed structs and enums
inside structs:

struct dtv_frontend_properties {
...
	struct {
	    u8			segment_count;
	    enum fe_code_rate	fec;
	    enum fe_modulation	modulation;
	    u8			interleaving;
	} layer[3];
...
};

The fields of the embedded struct are described as:

 * @layer:		ISDB per-layer data (only ISDB standard)
 * @layer.segment_count: Segment Count;
 * @layer.fec:		per layer code rate;
 * @layer.modulation:	per layer modulation;
 * @layer.interleaving:	 per layer interleaving.

kernel-lintdoc didn't like that:

	drivers/media/dvb-core/dvb_frontend.h:513 :ERROR: duplicate parameter definition 'layer'
	drivers/media/dvb-core/dvb_frontend.h:514 :ERROR: duplicate parameter definition 'layer'
	drivers/media/dvb-core/dvb_frontend.h:515 :ERROR: duplicate parameter definition 'layer'
	drivers/media/dvb-core/dvb_frontend.h:516 :ERROR: duplicate parameter definition 'layer'

2) it complains about function typedefs:

	drivers/media/dvb-core/demux.h:251 :WARN: typedef of function pointer not marked as typdef, use: 'typedef dmx_ts_cb' in the comment.
	drivers/media/dvb-core/demux.h:292 :WARN: typedef of function pointer not marked as typdef, use: 'typedef dmx_section_cb' in the comment.
	include/media/v4l2-ioctl.h:677 :WARN: typedef of function pointer not marked as typdef, use: 'typedef v4l2_kioctl' in the comment.
	include/media/v4l2-ctrls.h:106 :WARN: typedef of function pointer not marked as typdef, use: 'typedef v4l2_ctrl_notify_fnc' in the comment.
	include/media/v4l2-ctrls.h:606 :WARN: typedef of function pointer not marked as typdef, use: 'typedef v4l2_ctrl_filter' in the comment.
	include/media/v4l2-dv-timings.h:39 :WARN: typedef of function pointer not marked as typdef, use: 'typedef v4l2_check_dv_timings_fnc' in the comment.
	include/media/v4l2-dv-timings.h:39 :WARN: typedef of function pointer used uncommon code style: 'typedef bool v4l2_check_dv_timings_fnc(const struct v4l2_dv_timings *t, void *handle);'
	include/media/videobuf2-core.h:877 :WARN: typedef of function pointer not marked as typdef, use: 'typedef vb2_thread_fnc' in the comment.

3) this is actually a more complex problem: how to represent returned values
from the function callbacks. Maybe we'll need to patch kernel-doc. Right now,
it complains with:

	drivers/media/dvb-core/demux.h:397 :WARN: duplicate section name 'It returns'
	drivers/media/dvb-core/demux.h:415 :WARN: duplicate section name 'It returns'
	drivers/media/dvb-core/demux.h:431 :WARN: duplicate section name 'It returns'
	drivers/media/dvb-core/demux.h:444 :WARN: duplicate section name 'It returns'
	drivers/media/dvb-core/demux.h:462 :WARN: duplicate section name 'It returns'
	drivers/media/dvb-core/demux.h:475 :WARN: duplicate section name 'It returns'
	drivers/media/dvb-core/demux.h:491 :WARN: duplicate section name 'It returns'
	drivers/media/dvb-core/demux.h:507 :WARN: duplicate section name 'It returns'
	drivers/media/dvb-core/demux.h:534 :WARN: duplicate section name 'It returns'
	drivers/media/dvb-core/demux.h:542 :WARN: duplicate section name 'It returns'
	drivers/media/dvb-core/demux.h:552 :WARN: duplicate section name 'It returns'

4) Parse errors.

Those seem to be caused by some errors at the parser:

	include/media/v4l2-ctrls.h:809 :WARN: can't understand function proto: 'const char * const *v4l2_ctrl_get_menu(u32 id);'
	include/media/v4l2-dev.h:173 :WARN: no description found for parameter 'valid_ioctls\[BITS_TO_LONGS(BASE_VIDIOC_PRIVATE)\]'
	include/media/v4l2-dev.h:173 :WARN: no description found for parameter 'disable_locking\[BITS_TO_LONGS(BASE_VIDIOC_PRIVATE)\]'
	include/media/videobuf2-core.h:555 :ERROR: can't parse struct!


Thanks,
Mauro
