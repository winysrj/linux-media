Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34902 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727098AbeH0NUZ (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 27 Aug 2018 09:20:25 -0400
Date: Mon, 27 Aug 2018 11:34:30 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Shuah Khan <shuah@kernel.org>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:KERNEL SELFTEST FRAMEWORK"
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v6] Add udmabuf misc device
Message-ID: <20180827093430.ck2pf7lkxdt52n2h@sirius.home.kraxel.org>
References: <20180703075359.30349-1-kraxel@redhat.com>
 <20180703083757.GG7880@phenom.ffwll.local>
 <20180704055338.n3b7oexltaejqmcd@sirius.home.kraxel.org>
 <20180704080807.GH3891@phenom.ffwll.local>
 <20180704085825.nfkv5i7ultaavjve@sirius.home.kraxel.org>
 <20180704091954.GQ3891@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180704091954.GQ3891@phenom.ffwll.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hi,

> > Covering udmabuf.c maintainance is a different issue.  I could just add
> > myself to the existing entry, or create a new one specifically for
> > udmabuf.
> 
> That's what I meant, do a more specific entry to add yourself just for
> udmabuf.

Ok.  Back from summer vacation, finally found the time to continue
working on this.  Entry added, rebased to 4.19-rc1, v7 comes in a
moment.  Please review & ack.

thanks,
  Gerd
