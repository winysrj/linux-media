Return-path: <linux-media-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:34198 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754416AbdJJLYK (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 10 Oct 2017 07:24:10 -0400
Date: Tue, 10 Oct 2017 08:24:02 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: Re: [PATCH v7 4/7] media: open.rst: document devnode-centric and
 mc-centric types
Message-ID: <20171010082402.1bfe3b45@vento.lan>
In-Reply-To: <20171006122426.3yv4je6lzxf7ikqh@valkosipuli.retiisi.org.uk>
References: <cover.1506550930.git.mchehab@s-opensource.com>
        <f3435f2eb6417a4b16e036a492fc5044915892d1.1506550930.git.mchehab@s-opensource.com>
        <20171006122426.3yv4je6lzxf7ikqh@valkosipuli.retiisi.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Fri, 6 Oct 2017 15:24:27 +0300
Sakari Ailus <sakari.ailus@iki.fi> escreveu:

> > +When V4L2 was originally designed, there was only one type of
> > +media hardware control: via the **V4L2 device nodes**. We refer to this kind
> > +of control as **V4L2 device node centric** (or, simply, "**vdevnode-centric**").  
> 
> I think this could be easier understood if we start with the differences
> instead of what we call the types. I'd also refer to interfaces rather than
> their instances.
> 
> How about (pending finalising discussion on naming):
> 
> When **V4L2** was originally designed, the **V4L2 device** served the
> purpose of both control and data interfaces and there was no separation
> between the two interface-wise. V4L2 controls, setting inputs and outputs,
> format configuration and buffer related operations were all performed
> through the same **V4L2 device nodes**. Devices offering such interface are
> called **V4L2 device node centric**.
> 
> Later on, support for the **Media controller** interface was added to V4L2
> in order to better support complex **V4L2 aggregate devices** where the
> **V4L2** interface alone could no longer meaningfully serve as both a
> control and a data interface. On such aggregate devices, **V4L2** interface
> remains a data interface whereas control takes place through the **Media
> controller** and **V4L2 sub-device** interfaces. Stream control is an
> exception to this: streaming is enabled and disabled through the **V4L2**
> interface. These devices are called **Media controller centric**.
> 
> **MC-centric** aggregate devices provide more versatile control of the
> hardware than **V4L2 device node centric** devices. On **MC-centric**
> aggregate devices the **V4L2 sub-device nodes** represent specific parts of
> the **V4L2 aggregate device**, to which they enable control.
> 
> Also, the additional versatility of **MC-centric** aggregate devices comes
> with additional responsibilities, the main one of which is the requirements
> of the user configuring the device pipeline before starting streaming. This
> typically involves configuring the links using the **Media controller**
> interface and the media bus formats on pads (at both ends of the links)
> using the **V4L2 sub-device** interface.

Works for me. 

Except that I didn't like the idea of "aggregate devices". So, I kept
the previously agreed term "V4L2 hardware".

Also, as everything comes with a price, I added it on this paragraph:

	**MC-centric** V4L2 hardware provide more versatile control of the
	hardware than **V4L2 device node centric** devices at the expense of
	requiring device-specific userspace settings.

Finally, I'm now using :term:`foo` Sphinx directive on the patchset
(I'll send a new version soon) at the first time a term appears inside
a section[1].

[1] We might repeat that on every occurrence of a term, but:
	a) it sounded overkill to me;
	b) if we decide to change some term, there will be a lot
	   more stuff to be fixed, specially for terms in plural,
	   as a plural for :term:`device` would be
	   :term:`devices <device>`.
    Once we set this patchset into a stone, it could make sense to
    run some script that would replace every other occurrence of the
    glossary terms within Documentation/media/uapi/v4l to link to
    the glossary reference - but let's postpone this to be applied
    on a separate patchset.
    Btw, it probably makes sense to make the glossary as a general
    media book glossary - but again, this is out of topic for this
    patchset.


With this, the version I'm adding is:

<snippet>
When **V4L2** was originally designed, the
:term:`V4L2 device nodes <v4l2 device node>` served the purpose of both
control and data interfaces and there was no separation
between the two interface-wise. V4L2 controls, setting inputs and outputs,
format configuration and buffer related operations were all performed
through the same **V4L2 device nodes**. Devices offering such interface are
called **V4L2 device node centric**.

Later on, support for the :term:`media controller` interface was added
to V4L2 in order to better support complex :term:`V4L2 hardware` where the 
**V4L2** interface alone could no longer meaningfully serve as both a
control and a data interface. On such V4L2 hardware, **V4L2** interface
remains a data interface whereas control takes place through the 
:term:`media controller` and :term:`V4L2 sub-device` interfaces. Stream
control is an exception to this: streaming is enabled and disabled
through the **V4L2** interface. These devices are called
**Media controller centric**.

**MC-centric** V4L2 hardware provide more versatile control of the
hardware than **V4L2 device node centric** devices at the expense of
requiring device-specific userspace settings.

On **MC-centric** V4L2 hardware, the **V4L2 sub-device nodes** 
represent specific parts of the V4L2 hardware, to which they enable
control.

Also, the additional versatility of **MC-centric** V4L2 hardware comes
with additional responsibilities, the main one of which is the requirements
of the user configuring the device pipeline before starting streaming. This
typically involves configuring the links using the **Media controller**
interface and the media bus formats on pads (at both ends of the links)
using the **V4L2 sub-device** interface.
</snippet>



Thanks,
Mauro
