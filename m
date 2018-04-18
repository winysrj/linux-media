Return-path: <linux-media-owner@vger.kernel.org>
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:38126 "EHLO
        hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751870AbeDRJIE (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 18 Apr 2018 05:08:04 -0400
Date: Wed, 18 Apr 2018 12:08:01 +0300
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Souptick Joarder <jrdr.linux@gmail.com>
Cc: mchehab@kernel.org, jack@suse.cz, dan.j.williams@intel.com,
        akpm@linux-foundation.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, willy@infradead.org
Subject: Re: [PATCH] media: v4l2-core: Change return type to vm_fault_t
Message-ID: <20180418090801.uydntb4ruc7r472z@valkosipuli.retiisi.org.uk>
References: <20180417144305.GA31337@jordon-HP-15-Notebook-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180417144305.GA31337@jordon-HP-15-Notebook-PC>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Apr 17, 2018 at 08:13:06PM +0530, Souptick Joarder wrote:
> Use new return type vm_fault_t for fault handler. For
> now, this is just documenting that the function returns
> a VM_FAULT value rather than an errno. Once all instances
> are converted, vm_fault_t will become a distinct type.
> 
> Reference id -> 1c8f422059ae ("mm: change return type to
> vm_fault_t")
> 
> Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>

Subject should mention "videobuf"; videobuf is not part of V4L2 core
(albeit the directory structure would certainly seem to suggest that). With
that,

Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

-- 
Sakari Ailus
e-mail: sakari.ailus@iki.fi
