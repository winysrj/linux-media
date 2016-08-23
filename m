Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3-1.goneo.de ([85.220.129.38]:45598 "EHLO smtp3-1.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1757583AbcHWJyM (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 23 Aug 2016 05:54:12 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH v2 2/2] Documentation/sphinx: link dma-buf rsts
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160823060135.GJ24290@phenom.ffwll.local>
Date: Tue, 23 Aug 2016 11:20:23 +0200
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>, corbet@lwn.net,
        linux-doc@vger.kernel.org,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org Development"
        <dri-devel@lists.freedesktop.org>, linaro-mm-sig@lists.linaro.org,
        linux-media@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>
Content-Transfer-Encoding: 8BIT
Message-Id: <C5319F88-5156-4B47-B03D-40A8548CD4F1@darmarit.de>
References: <1471878705-3963-1-git-send-email-sumit.semwal@linaro.org> <1471878705-3963-3-git-send-email-sumit.semwal@linaro.org> <20160822124930.02dbbafc@vento.lan> <20160823060135.GJ24290@phenom.ffwll.local>
To: Sumit Semwal <sumit.semwal@linaro.org>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 23.08.2016 um 08:01 schrieb Daniel Vetter <daniel@ffwll.ch>:

> On Mon, Aug 22, 2016 at 12:49:30PM -0300, Mauro Carvalho Chehab wrote:
>> Em Mon, 22 Aug 2016 20:41:45 +0530
>> Sumit Semwal <sumit.semwal@linaro.org> escreveu:
>> 
>>> Include dma-buf sphinx documentation into top level index.
>>> 
>>> Signed-off-by: Sumit Semwal <sumit.semwal@linaro.org>
>>> ---
>>> Documentation/index.rst | 2 ++
>>> 1 file changed, 2 insertions(+)
>>> 
>>> diff --git a/Documentation/index.rst b/Documentation/index.rst
>>> index e0fc72963e87..8d05070122c2 100644
>>> --- a/Documentation/index.rst
>>> +++ b/Documentation/index.rst
>>> @@ -14,6 +14,8 @@ Contents:
>>>    :maxdepth: 2
>>> 
>>>    kernel-documentation
>>> +   dma-buf/intro
>>> +   dma-buf/guide
>>>    media/media_uapi
>>>    media/media_kapi
>>>    media/dvb-drivers/index
>> 
>> IMHO, the best would be, instead, to add an index with a toctree
>> with both intro and guide, and add dma-buf/index instead.
>> 
>> We did that for media too (patches not merged upstream yet), together
>> with a patchset that will allow building just a subset of the books.

Since 606b9ac, one more *pro* of a index.rst file in a sub-folder is,
that you can reduce your roundtrips. Add a conf.py to your subfolder
and compile only your sub-folder with e.g.

  make SPHINXDIRS="dma-buf" htmldocs

* http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=606b9ac81a63ab3adb7e61206b9ae34ee186a89d

One / the example (Mauro mentioned) is media commit b32feba

* http://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/commit/?id=b32febad77068b4a28daf7b7e063438d0cca8a42

> I'm also not too sure about whether dma-buf really should be it's own
> subdirectory. It's plucked from the device-drivers.tmpl, I think an
> overall device-drivers/ for all the misc subsystems and support code would
> be better.

If the sub-folder named 'device-drivers' use:
 
  make SPHINXDIRS="device-drivers" htmldocs

-- Markus --


> Then one toc there, which fans out to either kernel-doc and
> overview docs.
> -Daniel
> 
>> 
>> Regards,
>> Mauro
>> 
>> PS.: That's the content of our index.rst file, at
>> Documentation/media/index.rst:
>> 
>> Linux Media Subsystem Documentation
>> ===================================
>> 
>> Contents:
>> 
>> .. toctree::
>>   :maxdepth: 2
>> 
>>   media_uapi
>>   media_kapi
>>   dvb-drivers/index
>>   v4l-drivers/index
>> 
>> .. only::  subproject
>> 
>>   Indices
>>   =======
>> 
>>   * :ref:`genindex`
>> 
>> 
>> Thanks,
>> Mauro
>> _______________________________________________
>> dri-devel mailing list
>> dri-devel@lists.freedesktop.org
>> https://lists.freedesktop.org/mailman/listinfo/dri-devel
> 
> -- 
> Daniel Vetter
> Software Engineer, Intel Corporation
> http://blog.ffwll.ch

