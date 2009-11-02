Return-path: <linux-media-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.27]:43247 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbZKBUfV (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 2 Nov 2009 15:35:21 -0500
Received: by ey-out-2122.google.com with SMTP id d26so488914eyd.19
        for <linux-media@vger.kernel.org>; Mon, 02 Nov 2009 12:35:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4AEDB05E.1090704@googlemail.com>
References: <4AEDB05E.1090704@googlemail.com>
Date: Mon, 2 Nov 2009 21:27:44 +0100
Message-ID: <9ac6f40e0911021227h166f798djf9fbec10a5d72179@mail.gmail.com>
Subject: Re: bug in changeset 13239:54535665f94b ?
From: e9hack@googlemail.com
To: linux-media@vger.kernel.org
Cc: e9hack@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

the BUG is in vidioc_streamoff() for the saa7146. This function
releases all buffers first, and stops the capturing and dma tranfer of
the saa7146 as second. If the page table, which is currently used by
the saa7146, is modified by another thread, the saa7146 writes
anywhere to the physical RAM. IMHO vidioc_streamoff() must stop the
saa7146 first and may then release the buffers.

Regards,
Hartmut
