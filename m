Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:27298 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754039AbcHVLwu (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 07:52:50 -0400
From: Jani Nikula <jani.nikula@intel.com>
To: Markus Heiser <markus.heiser@darmarit.de>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org
Subject: Re: RFC? [PATCH] docs-rst: kernel-doc: better output struct members
In-Reply-To: <921CD8C1-C4E7-4052-A8B1-B9DFE9159122@darmarit.de>
References: <45996a8dc149f7de6ed09d703b76cb65e55b7a9a.1471781478.git.mchehab@s-opensource.com> <970CC2BB-EFCC-41D7-9BFD-3F295DDB1FE4@darmarit.de> <20160822070633.163af4b5@vento.lan> <874m6duk8o.fsf@intel.com> <921CD8C1-C4E7-4052-A8B1-B9DFE9159122@darmarit.de>
Date: Mon, 22 Aug 2016 14:52:42 +0300
Message-ID: <87wpj9t3zp.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, 22 Aug 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
> Am 22.08.2016 um 13:16 schrieb Jani Nikula <jani.nikula@intel.com>:
>
>> On Mon, 22 Aug 2016, Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
>>> Markus,
>>> 
>>> Em Mon, 22 Aug 2016 10:56:01 +0200
>>> Markus Heiser <markus.heiser@darmarit.de> escreveu:
>>> 
>>>> Am 21.08.2016 um 14:11 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
>>>> 
>>>>> Right now, for a struct, kernel-doc produces the following output:
>>>>> 
>>>>> 	.. c:type:: struct v4l2_prio_state
>>>>> 
>>>>> 	   stores the priority states
>>>>> 
>>>>> 	**Definition**
>>>>> 
>>>>> 	::
>>>>> 
>>>>> 	  struct v4l2_prio_state {
>>>>> 	    atomic_t prios[4];
>>>>> 	  };
>>>>> 
>>>>> 	**Members**
>>>>> 
>>>>> 	``atomic_t prios[4]``
>>>>> 	  array with elements to store the array priorities
>>>>> 
>>>>> Putting a member name in verbatim and adding a continuation line
>>>>> causes the LaTeX output to generate something like:
>>>>> 	item[atomic_t prios\[4\]] array with elements to store the array priorities  
>>>> 
>>>> 
>>>> Right now, the description of C-struct members is a simple rest-definition-list 
>>>> (not in the c-domain). It might be better to use the c-domain for members:
>>>> 
>>>>  http://www.sphinx-doc.org/en/stable/domains.html#directive-c:member
>>>> 
>>>> But this is not the only thing we have to consider. To make a valid C-struct
>>>> description (with targets/references in the c-domain) we need a more
>>>> *structured* reST markup where the members are described in the block-content
>>>> of the struct directive. E.g:
>>>> 
>>>> <SNIP> -----------
>>>> |.. c:type:: struct v4l2_subdev_ir_ops
>>>> |
>>>> |   operations for IR subdevices
>>>> |
>>>> |   .. c:member::  int (* rx_read) (struct v4l2_subdev *sd, u8 *buf, size_t count,ssize_t *num)
>>>> |
>>>> <SNIP> -----------
>>>> 
>>>> By this small example, you see, that we have to discuss the whole markup 
>>>> produced by the kernel-doc script (function arguments, unions etc.). 
>>>> IMHO, since kernel-doc is widely used, this should be a RFC.
>>> 
>>> I tried using c:member. It won't work on LaTeX output, as it will
>>> still put everything into a LaTeX item, with doesn't do line breaks.
>> 
>> I've tried c:member before, and I'm not convinced it buys us anything
>> useful. I'm also not convinced we'd need more structured rst markup
>> within struct or function descriptions in addition to what we currently
>> have. Keep it simple.
>> 
>> BR,
>> Jani.
>
> It buys, that we stay in the c-domain and we can refer to the members
> with the :c:member role. E.g :c:member:`v4l2_subdev_ir_ops.rx_read`.

Yes, it allows anchors to members, while detaching the member
descriptions from the struct descriptions. In the output, there is no
perceivable parent-child relationship between the struct and its
members. Arguably the resulting documentation is harder to follow with
c:member than without. I think it's sufficient to link to the struct
descriptions. It's not enough to say that theoretically using c:member
is the right thing; it needs to be better in practice too.

BR,
Jani.






>
> -- Markus --
>  
>
>

-- 
Jani Nikula, Intel Open Source Technology Center
