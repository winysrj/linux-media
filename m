Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ee0-f49.google.com ([74.125.83.49]:58697 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbaCYK4f (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 25 Mar 2014 06:56:35 -0400
Received: by mail-ee0-f49.google.com with SMTP id c41so279280eek.22
        for <linux-media@vger.kernel.org>; Tue, 25 Mar 2014 03:56:34 -0700 (PDT)
Date: Tue, 25 Mar 2014 11:56:29 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Seung-Woo Kim <sw0312.kim@samsung.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
	Bin Wang <binw@marvell.com>,
	Linaro MM SIG <linaro-mm-sig@lists.linaro.org>,
	dri-devel <dri-devel@lists.freedesktop.org>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [Linaro-mm-sig] [PATCH] dma-buf: add meta data attachment
Message-ID: <20140325105629.GY26878@phenom.ffwll.local>
References: <1395378261-17408-1-git-send-email-binw@marvell.com>
 <CAO_48GFPTn26szh8ffVuohGC_FZ+hdR=9V_YnS82t_UZ9nNMJw@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F70430F53F33F7D@SC-VEXCH1.marvell.com>
 <CAKMK7uFNw=7zeMOyscx6J7K7oZVoG8XkNhgdjmeJUKEusPzNDg@mail.gmail.com>
 <53314A9E.908@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53314A9E.908@samsung.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Mar 25, 2014 at 06:21:34PM +0900, Seung-Woo Kim wrote:
> Hi all,
> 
> On 2014년 03월 24일 16:35, Daniel Vetter wrote:
> > Hi all,
> >
> > Adding piles more people.
> >
> > For the first case of caching the iommu mapping there's different
> > answers, depening upon the exact case:
> >
> > 1) You need to fix your userspace to not constantly re-establish the sharing.
> >
> > 2) We need to add streaming dma support for real to dma-bufs so that
> > the mapping can be kept while we transfer ownership around. Thus far
> > no one really needed this though since usually you don't actually do
> > cpu access.
> >
> > 3) You need opportunistic caching of imported/exported buffer objects
> > and their mappings. For this you need a) subsystem import/export
> > support which guarantees you to hand out the same dma-buf/native
> > object again upon re-export or re-import (drm has it) b) some
> > opportunistic caching of buffer objects (pretty much are real gpu drm
> > drivers have it). No need of any metadata scheme, and given how much
> > fun I've had implemented this for drm I don't you can make your
> > metadata scheme work in a sane or correct way wrt lifetimes.
> >
> > For caching the iommu mapping if the iommu is the same for multiple devices:
> >
> > 1) We need some way to figure out which iommu serves which devices.
> >
> > 2) The exporter needs to consult this and might just hand out the same
> > sg mapping out again if it wants to.
> >
> > No need for importers to do fancy stuff, or attach any
> > importer-visible metadata to dma-bufs. Of course duplicating this code
> > all over the place is a but uncool, so I expect that eventually we'll
> > have a generic exporter implementation, at least for non-swappable
> > buffers. drm/gem is a bit special here ...
> >
> > In general I don't like the idea of arbitrary metadata at all, sounds
> > prone to abuse with crazy lifetime/refcounting rules for the objects
> > involved. Also I think for a lot of your examples (like debugging) it
> > would be much better if we have a standardized piece of metadata so
> > that all drivers/platforms can use the same tooling.
> >
> > And it feels like I'm writing such a mail every few months ...
> 
> I posted concept about importer priv of dma-buf, and it seems that this
> patch is partly from similar requirement - iommu map/unmap.
> 
> And at that time, Daniel agreed at least the issue, that unnecessary
> map/unmap can repeatedly called, is also in the drm gem.
> http://lists.freedesktop.org/archives/dri-devel/2013-June/039469.html
> 
> So I agree about the necessary of some data of dma-buf for general
> importer even though the data can be shared between different subsystems.

Oh right, I guess someone has to implement this eventually ;-)
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
