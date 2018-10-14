Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48358 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726042AbeJNHuD (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sun, 14 Oct 2018 03:50:03 -0400
Date: Sun, 14 Oct 2018 02:11:26 +0200
From: Eugene Syromiatnikov <esyr@redhat.com>
To: tbhardwa@codeaurora.org
Cc: "'Zhang, Ning A'" <ning.a.zhang@intel.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: question about V4L2_MEMORY_USERPTR on 64bit applications
Message-ID: <20181014001126.GA717@asgard.redhat.com>
References: <1539313441.21249.3.camel@intel.com>
 <1539318782.21249.7.camel@intel.com>
 <000601d461eb$a1f7afc0$e5e70f40$@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000601d461eb$a1f7afc0$e5e70f40$@codeaurora.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Oct 12, 2018 at 10:52:51AM +0530, tbhardwa@codeaurora.org wrote:
> (in 64 bit userspace long is 32-bit)

Not on Linux.

$ cat /tmp/c.c
int main(void)
{
        return sizeof(long);
}
$ gcc /tmp/c.c
$ ./a.out; echo $?
8
$ file ./a.out
./a.out: ELF 64-bit LSB pie executable, 64-bit PowerPC or cisco 7500, version 1 (SYSV), dynamically linked, interpreter /lib64/ld64.so.2, for GNU/Linux 3.10.0, BuildID[sha1]=dad78822e741b7900dc7568222822d5d63c31a6c, not stripped
