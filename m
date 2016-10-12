Return-path: <linux-media-owner@vger.kernel.org>
Received: from out0-138.mail.aliyun.com ([140.205.0.138]:48427 "EHLO
        out0-138.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751982AbcJLDgd (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Tue, 11 Oct 2016 23:36:33 -0400
Reply-To: "Hillf Danton" <hillf.zj@alibaba-inc.com>
From: "Hillf Danton" <hillf.zj@alibaba-inc.com>
To: "'Ruchi Kandoi'" <kandoiruchi@google.com>,
        <gregkh@linuxfoundation.org>, <arve@android.com>,
        <riandrews@android.com>, <sumit.semwal@linaro.org>,
        <arnd@arndb.de>, <labbott@redhat.com>, <viro@zeniv.linux.org.uk>,
        <jlayton@poochiereds.net>, <bfields@fieldses.org>,
        <mingo@redhat.com>, <peterz@infradead.org>,
        <akpm@linux-foundation.org>, <keescook@chromium.org>,
        <mhocko@suse.com>, <oleg@redhat.com>, <john.stultz@linaro.org>,
        <mguzik@redhat.com>, <jdanis@google.com>, <adobriyan@gmail.com>,
        <ghackmann@google.com>, <kirill.shutemov@linux.intel.com>,
        <vbabka@suse.cz>, <dave.hansen@linux.intel.com>,
        <dan.j.williams@intel.com>, <hannes@cmpxchg.org>,
        <iamjoonsoo.kim@lge.com>, <luto@kernel.org>, <tj@kernel.org>,
        <vdavydov.dev@gmail.com>, <ebiederm@xmission.com>,
        <linux-kernel@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <linux-media@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
        <linaro-mm-sig@lists.linaro.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-mm@kvack.org>
References: <1476229810-26570-1-git-send-email-kandoiruchi@google.com> <1476229810-26570-7-git-send-email-kandoiruchi@google.com>
In-Reply-To: <1476229810-26570-7-git-send-email-kandoiruchi@google.com>
Subject: Re: [RFC 6/6] drivers: staging: ion: add ION_IOC_TAG ioctl
Date: Wed, 12 Oct 2016 11:29:23 +0800
Message-ID: <00b201d22438$d51aaf30$7f500d90$@alibaba-inc.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Language: zh-cn
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday, October 12, 2016 7:50 AM Ruchi Kandoi wrote:
> +/**
> + * struct ion_fd_data - metadata passed from userspace for a handle

s/fd/tag/ ?

> + * @handle:	a handle
> + * @tag: a string describing the buffer
> + *
> + * For ION_IOC_TAG userspace populates the handle field with
> + * the handle returned from ion alloc and type contains the memtrack_type which
> + * accurately describes the usage for the memory.
> + */
> +struct ion_tag_data {
> +	ion_user_handle_t handle;
> +	char tag[ION_MAX_TAG_LEN];
> +};
> +

