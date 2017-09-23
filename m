Return-path: <linux-media-owner@vger.kernel.org>
Received: from lb3-smtp-cloud8.xs4all.net ([194.109.24.29]:52019 "EHLO
        lb3-smtp-cloud8.xs4all.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750762AbdIWHfk (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Sat, 23 Sep 2017 03:35:40 -0400
Subject: Re: [PATCH 0/8] [media] v4l2-core: Fine-tuning for some function
 implementations
To: SF Markus Elfring <elfring@users.sourceforge.net>,
        linux-media@vger.kernel.org
References: <9268b60d-08ba-c64e-1848-f84679d64f80@users.sourceforge.net>
 <20161227115111.GN16630@valkosipuli.retiisi.org.uk>
 <b804f4dd-392e-ae8e-41de-a02260fef550@xs4all.nl>
 <8241c145-03f4-6dd2-401e-7d251cd5d251@users.sourceforge.net>
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Jan Kara <jack@suse.cz>,
        Javier Martinez Canillas <javier@osg.samsung.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Lorenzo Stoakes <lstoakes@gmail.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
From: Hans Verkuil <hverkuil@xs4all.nl>
Message-ID: <f48e9219-3092-1b1f-4458-f9437746bf14@xs4all.nl>
Date: Sat, 23 Sep 2017 09:35:31 +0200
MIME-Version: 1.0
In-Reply-To: <8241c145-03f4-6dd2-401e-7d251cd5d251@users.sourceforge.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 22/09/17 22:08, SF Markus Elfring wrote:
>> Sorry Markus, just stay away from the videobuf-* sources.
> 
> Will the software evolution be continued for related source files?
> Are there any update candidates left over in the directory “v4l2-core”?

Sorry, I don't understand the question. We don't want to touch the
videobuf-* files unless there is a very good reason. That old videobuf
framework is deprecated and the code is quite fragile (i.e. easy to break
things).

Everything else in that directory is under continuous development.

It's core code though, so it gets a much more in-depth code review than
patches for e.g. a driver.

Regards,

	Hans
