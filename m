Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:48482 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932847AbeE2Ks4 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 29 May 2018 06:48:56 -0400
Date: Tue, 29 May 2018 12:48:55 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
To: dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Shuah Khan <shuah@kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DMA BUFFER SHARING FRAMEWORK"
        <linux-media@vger.kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK"
        <linaro-mm-sig@lists.linaro.org>,
        "open list:KERNEL SELFTEST FRAMEWORK"
        <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v3] Add udmabuf misc device
Message-ID: <20180529104855.vvrfdtbgrsqj27ga@sirius.home.kraxel.org>
References: <20180525140808.12714-1-kraxel@redhat.com>
 <20180529082327.GF3438@phenom.ffwll.local>
 <20180529084406.GI3438@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180529084406.GI3438@phenom.ffwll.local>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

  Hi,

> > > qemu test branch:
> > >   https://git.kraxel.org/cgit/qemu/log/?h=sirius/udmabuf
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

> > > +	if (!shmem_mapping(file_inode(ubuf->filp)->i_mapping))
> > > +		goto err_free_ubuf;
> 
> Can/should we test here that the memfd has a locked down size here?

Makes sense.  Suggested way to check that?  unstatic memfd_get_seals()
function (mm/shmem.c)?  Or is there some better way?

Also which seals should we require?  Is F_SEAL_SHRINK enough?

> On that: Link to userspace patches/git tree using this would be nice.

See above.

cheers,
  Gerd
