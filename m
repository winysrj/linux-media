Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.goneo.de ([85.220.129.33]:50854 "EHLO smtp2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752089AbcHVLmY (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Mon, 22 Aug 2016 07:42:24 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: RFC? [PATCH] docs-rst: kernel-doc: better output struct members
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20160822070633.163af4b5@vento.lan>
Date: Mon, 22 Aug 2016 13:42:08 +0200
Cc: Jani Nikula <jani.nikula@intel.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-doc@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <FAB61380-9B5D-444F-A13B-3C24D9672417@darmarit.de>
References: <45996a8dc149f7de6ed09d703b76cb65e55b7a9a.1471781478.git.mchehab@s-opensource.com> <970CC2BB-EFCC-41D7-9BFD-3F295DDB1FE4@darmarit.de> <20160822070633.163af4b5@vento.lan>
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


Am 22.08.2016 um 12:06 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:

> Markus,
> 
> Em Mon, 22 Aug 2016 10:56:01 +0200
> Markus Heiser <markus.heiser@darmarit.de> escreveu:
> 
>> Am 21.08.2016 um 14:11 schrieb Mauro Carvalho Chehab <mchehab@s-opensource.com>:
>> 
>>> Right now, for a struct, kernel-doc produces the following output:
>>> 
>>> 	.. c:type:: struct v4l2_prio_state
>>> 
>>> 	   stores the priority states
>>> 
>>> 	**Definition**
>>> 
>>> 	::
>>> 
>>> 	  struct v4l2_prio_state {
>>> 	    atomic_t prios[4];
>>> 	  };
>>> 
>>> 	**Members**
>>> 
>>> 	``atomic_t prios[4]``
>>> 	  array with elements to store the array priorities
>>> 
>>> Putting a member name in verbatim and adding a continuation line
>>> causes the LaTeX output to generate something like:
>>> 	item[atomic_t prios\[4\]] array with elements to store the array priorities  
>> 
>> 
>> Right now, the description of C-struct members is a simple rest-definition-list 
>> (not in the c-domain). It might be better to use the c-domain for members:
>> 
>>  http://www.sphinx-doc.org/en/stable/domains.html#directive-c:member
>> 
>> But this is not the only thing we have to consider. To make a valid C-struct
>> description (with targets/references in the c-domain) we need a more
>> *structured* reST markup where the members are described in the block-content
>> of the struct directive. E.g:
>> 
>> <SNIP> -----------
>> |.. c:type:: struct v4l2_subdev_ir_ops
>> |
>> |   operations for IR subdevices
>> |
>> |   .. c:member::  int (* rx_read) (struct v4l2_subdev *sd, u8 *buf, size_t count,ssize_t *num)
>> |
>> <SNIP> -----------
>> 
>> By this small example, you see, that we have to discuss the whole markup 
>> produced by the kernel-doc script (function arguments, unions etc.). 
>> IMHO, since kernel-doc is widely used, this should be a RFC.
> 
> I tried using c:member. It won't work on LaTeX output, as it will
> still put everything into a LaTeX item, with doesn't do line breaks.
> 
> Also, according to Sphinx manual at http://www.sphinx-doc.org/en/stable/domains.html
> The syntax is:
> 
> 	.. c:member:: type name
> 
> 	    Describes a C struct member. Example signature:
> 
> 		.. c:member:: PyObject* PyTypeObject.tp_bases
> 
> So, it expects <type> <member> as arguments. If the manual is right, it
> would be expecting, instead, the weird syntax:
> 
>   .. c:member::  int (*) (struct v4l2_subdev *sd, u8 *buf, size_t count,ssize_t *num) rx_read
> 
> With hurts my eyes.

Argh, you are right ... but it is very confusing. I made a small test::


<SNIP> ------------

.. c:type:: struct v4l2_subdev_ir_ops_001

   .. c:member::  int (*) (struct v4l2_subdev *sd, u8 *buf, size_t count,ssize_t *num) rx_read

      lorem ipsum


.. c:type:: struct v4l2_subdev_ir_ops_002

   operations for IR subdevices

   .. c:member::  int (* rx_read) (struct v4l2_subdev *sd, u8 *buf, size_t count,ssize_t *num)

      lorem ipsum


Test refs
=========

* :c:member:`v4l2_subdev_ir_ops_001.rx_read`
* :c:member:`v4l2_subdev_ir_ops_002.rx_read`

<SNIP> ------------


It seems, the c-parser is very dump, the v4l2_subdev_ir_ops_002.rx_read link
is closed, the 001 not ... a look at the sources:

* reg-exprs: https://github.com/sphinx-doc/sphinx/blob/master/sphinx/domains/c.py#L29

And the following snippet is all about handling signatures (of func, type, member .. directives)

m = c_funcptr_sig_re.match(sig)
if m is None:
    m = c_sig_re.match(sig)
if m is None:
    raise ValueError('no match')
rettype, name, arglist, const = m.groups()

In short: since the signature parsing is such worse, we can't predict
how type and name is parsed ... argh.

> As I guess we don't want to maintain ourselves a LaTeX output Sphinx
> plugin forked from upstream,

Agree

> I guess that a more definitive solution
> would involve overriding  the parser for c:member in a way that it would
> produce an output like the one in this path, while creating the proper
> c domain reference for the structure member inside the C domain.

Summarized:

* The c-parser of the Sphinx c-domain, is worse. BTW this is the next
  c-parser implementation used in the toolchain (parse-headers, kernel-doc)
  https://www.mail-archive.com/linux-media@vger.kernel.org/msg101440.html

* Even if we use a member-directive in the block of a type directive,
  it will nod be rendered well in the latex / pdf output.

OK, with this in mind, I agree with Jani ... "keep it simple" ;-)

-- Markus --


