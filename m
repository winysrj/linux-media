Return-path: <linux-media-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:52656 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754321AbaDKNFa (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 11 Apr 2014 09:05:30 -0400
Received: from eucpsbgm2.samsung.com (unknown [203.254.199.245])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0N3V00K1BB129A70@mailout4.w1.samsung.com> for
 linux-media@vger.kernel.org; Fri, 11 Apr 2014 14:05:26 +0100 (BST)
Message-id: <5347E894.5010401@samsung.com>
Date: Fri, 11 Apr 2014 15:05:24 +0200
From: Tomasz Stanislawski <t.stanislaws@samsung.com>
MIME-version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>, linux-media@vger.kernel.org
Cc: pawel@osciak.com, sakari.ailus@iki.fi, m.szyprowski@samsung.com,
	s.nawrocki@samsung.com, Hans Verkuil <hans.verkuil@cisco.com>
Subject: Re: [REVIEWv3 PATCH 09/13] vb2: add vb2_fileio_is_active and check it
 more often
References: <1397203879-37443-1-git-send-email-hverkuil@xs4all.nl>
 <1397203879-37443-10-git-send-email-hverkuil@xs4all.nl>
In-reply-to: <1397203879-37443-10-git-send-email-hverkuil@xs4all.nl>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Hans,

On 04/11/2014 10:11 AM, Hans Verkuil wrote:
> From: Hans Verkuil <hans.verkuil@cisco.com>
> 
> Added a vb2_fileio_is_active inline function that returns true if fileio
> is in progress. Check for this too in mmap() (you don't want apps mmap()ing
> buffers used by fileio) and expbuf() (same reason).

Why? I expect that there is no sane use case for using
mmap() and expbuf in read/write mode but why forbidding this.

Could you provide a reason?

Regard,
Tomasz Stanislawski

> 
> In addition drivers should be able to check for this in queue_setup() to
> return an error if an attempt is made to read() or write() with
> V4L2_FIELD_ALTERNATE being configured. This is illegal (there is no way
> to pass the TOP/BOTTOM information around using file I/O).
> 
> However, in order to be able to check for this the init_fileio function
> needs to set q->fileio early on, before the buffers are allocated. So switch
> to using internal functions (__reqbufs, vb2_internal_qbuf and
> vb2_internal_streamon) to skip the fileio check. Well, that's why the internal
> functions were created...
> 
> Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
> Acked-by: Pawel Osciak <pawel@osciak.com>
> Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>

