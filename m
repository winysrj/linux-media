Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp3.goneo.de ([85.220.129.37]:49504 "EHLO smtp3.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933171AbcJ0Uxk (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 27 Oct 2016 16:53:40 -0400
Subject: Re: Documentation/media/uapi/cec/ sporadically unnecessarily
 rebuilding
To: Jani Nikula <jani.nikula@intel.com>,
        Markus Heiser <markus.heiser@darmarit.de>
References: <871sz6p17k.fsf@intel.com>
 <F520076A-A05A-42B3-B416-288E67833AA9@darmarit.de> <87lgx9lu9a.fsf@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
From: Markus Heiser <markus.heiser@darmarit.de>
Message-ID: <e40e560f-f9f7-1725-edbe-978aeb93fbac@darmarit.de>
Date: Thu, 27 Oct 2016 22:53:24 +0200
MIME-Version: 1.0
In-Reply-To: <87lgx9lu9a.fsf@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>



On 27.10.2016 16:52, Jani Nikula wrote:
> On Thu, 27 Oct 2016, Markus Heiser <markus.heiser@darmarit.de> wrote:
>> Hi Jani,
>>
>> Am 24.10.2016 um 11:04 schrieb Jani Nikula <jani.nikula@intel.com>:
>>
>>> I think I saw some of this in the past [1], but then couldn't reproduce
>>> it after all. Now I'm seeing it again. Sporadically
>>> Documentation/media/uapi/cec/ gets rebuilt on successive runs of make
>>> htmldocs, even when nothing has changed.
>>>
>>> Output of 'make SPHINXOPTS="-v -v" htmldocs' attached for both cases.
>>>
>>> Using Sphinx (sphinx-build) 1.4.6
>>
>> I can't see what's  wrong with your "rebuild" file ...
>>
>> <build-cec-rebuilding.txt --------->
>> loading pickled environment... done
>> building [mo]: targets for 0 po files that are out of date
>> building [html]: targets for 0 source files that are out of date
>> updating environment: 0 added, 0 changed, 0 removed
>> looking for now-outdated files... none found
>> no targets are out of date.
>> build succeeded.
>>   HTML    Documentation/DocBook/index.html
>> <build-cec-rebuilding.txt --------->
>
> Awesome, I screwed up the file names, please check again with
> build-cec-rebuilding.txt <-> build-ok.txt...

Ah, ok .. I can reproduce the error.

It seems that sphinx's ".. toctree::" don't like it, if you
build a structure where severals ".. toctrees" in the same
folder include files of this folder.

E.g. if you have "myfolder" with "index.rst", "f1.rst"
and "f2.rst" in (content see below) and you rebuild it
5 or more times, the files f1.rst and f2.rst will
sporadically rebuild.

May I have time to find the bug and send a fix to sphinx.

-- Markus --

------------------------------------------------------
index
=====

.. toctree::
     :maxdepth: 1
     :numbered:

     f1

------------------------------------------------------
f1
==

.. toctree::
     :maxdepth: 1
     :numbered:

     f2

------------------------------------------------------
f2
==

lorem
------------------------------------------------------
