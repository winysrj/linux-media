Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:53074
        "EHLO osg.samsung.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753120AbdIDBRv (ORCPT
        <rfc822;linux-media@vger.kernel.org>); Sun, 3 Sep 2017 21:17:51 -0400
Date: Sun, 3 Sep 2017 22:17:38 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: Honza =?UTF-8?B?UGV0cm91xaE=?= <jpetrous@gmail.com>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: Re: [PATCH v2 00/26] Improve DVB documentation and reduce its gap
Message-ID: <20170903221738.1b4b2e28@vento.lan>
In-Reply-To: <CAJbz7-29pV9u0UZUC+sUtncsCbqbjNToA-yANJ7hExLRFw_tiQ@mail.gmail.com>
References: <cover.1504272067.git.mchehab@s-opensource.com>
        <CAJbz7-29pV9u0UZUC+sUtncsCbqbjNToA-yANJ7hExLRFw_tiQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Sun, 3 Sep 2017 22:05:23 +0200
Honza Petrouš <jpetrous@gmail.com> escreveu:

> > There is still a gap at the CA API, as there are three ioctls that are used
> > only by a few drivers and whose structs are not properly documented:
> > CA_GET_MSG, CA_SEND_MSG and CA_SET_DESCR.
> >
> > The first two ones seem to be related to a way that a few drivers
> > provide to send/receive messages.  
> 
> I never seen usage of such R/W ioctls, all drivers I have access to
> are using read()/write() variant of communication.

Yeah, the normal usage is to use R/W syscalls.

> BTW, I just remembered dvblast app, part of videolan.org:
> 
> http://www.videolan.org/projects/dvblast.html
> 
> which is using CA_GET_MSG/CA_SEND_MSG:
> 
> https://code.videolan.org/videolan/dvblast/blob/master/en50221.c

>From the ca_msg struct:

	/* a message to/from a CI-CAM */
	struct ca_msg {
		unsigned int index;
		unsigned int type;
		unsigned int length;
		unsigned char msg[256];
	};

It only uses length and msg fields. Describing those seem
quite obvious. However, what "index" and "type" means?

Within the Kernel, only two drivers implement it:

	$ git grep -l ca_msg drivers/
	drivers/media/firewire/firedtv-ci.c
	drivers/media/pci/bt8xx/dst_ca.c

At the dst_ca driver, checking for those fields don't give any
useful result:
	$ grep index drivers/media/pci/bt8xx/dst_ca.c
	(nothing)
	$ grep type drivers/media/pci/bt8xx/dst_ca.c
	// Copy application_type, application_manufacturer and manufacturer_code
	p_ca_caps->slot_type = 1;
	p_ca_caps->descr_type = 1;
		p_ca_slot_info->type = CA_CI;
		p_ca_slot_info->type = CA_CI;

(btw, using "1" for slot_type and descr_type there seems a very bad
thing)

The code at ca_get_message(), handle_dst_tag(), ca_set_pmt(), etc also
doesn't seem to be using neither one of those fields.

The same happens at firedtv-ci: it also doesn't seem to be using
none of those fields.

It should be noticed that, the dst_ca seems to allow more than one
descrambler:

	p_ca_caps->descr_num = slot_cap[7];

Yet, the index is not used. So, it doesn't seem to be related to
the descrambler index (or there's an implementation bug there - and
at dvblast - as none uses it).

What *I* suspect is that this were meant to be used for either
CA index/type or DESCR index/type, but, when this got implemented,
people discovered that this would be useless and never actually
used those fields. Yet, I may be completely wrong and those were
added to mean something else.

If so, then we could just change the struct to:

	struct ca_msg {
		unsigned int reserved[2];
		unsigned int length;
		unsigned char msg[256];
	};

And document just length and msg.

Thanks,
Mauro
