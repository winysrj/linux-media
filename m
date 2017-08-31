Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:25420 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751667AbdHaQg6 (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Thu, 31 Aug 2017 12:36:58 -0400
From: Jani Nikula <jani.nikula@linux.intel.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-media <linux-media@vger.kernel.org>
Subject: Re: [PATCH 1/2] docs: kernel-doc comments are ASCII
In-Reply-To: <87d17b90zb.fsf@intel.com>
References: <54c23e8e-89c0-5cea-0dcc-e938952c5642@infradead.org> <20170830152314.0486fafb@lwn.net> <3390facf-69ae-ba18-8abe-09b5695a6b31@infradead.org> <20170831064941.1fb18d20@vento.lan> <87h8wn98bv.fsf@intel.com> <20170831105602.5607fe52@vento.lan> <20170831081721.38be05ef@lwn.net> <f9e30c84-7ad7-39dd-a39f-f62581f0b893@infradead.org> <87d17b90zb.fsf@intel.com>
Date: Thu, 31 Aug 2017 19:36:39 +0300
Message-ID: <87a82f8zjc.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 31 Aug 2017, Jani Nikula <jani.nikula@linux.intel.com> wrote:
> On Thu, 31 Aug 2017, Randy Dunlap <rdunlap@infradead.org> wrote:
>> On 08/31/17 07:17, Jonathan Corbet wrote:
>>> On Thu, 31 Aug 2017 10:56:26 -0300
>>> Mauro Carvalho Chehab <mchehab@s-opensource.com> wrote:
>>> 
>>>> It should have something to do with python version and/or to some
>>>> locale info at the system, as neither I or Jon can reproduce it.
>>> 
>>> I can't reproduce it here, but I have certainly seen situations where
>>> Python 2 wants to run with the ascii codec by default.
>>> 
>>> Note that the exception happens in our Sphinx extension, not in Sphinx
>>> itself.  We've had other non-ascii text in our docs, so I think Sphinx is
>>> doing the right thing.  The problem is with our own code.  If I could
>>> reproduce it, it shouldn't be too hard to track down - take out that
>>> massive "except anything" block and see where it explodes.
>>> 
>>> Randy, which distribution are you running, and are you using their version
>>> of Sphinx?
>>
>> opensuse LEAP 42.2
>> Yes, their sphinx 1.3.1.
>
> What's your LANG setting? I think that's what it boils down to, and
> trying to work around non-UTF-8 LANG in both python 2 and 3 compatible
> ways.
>
> The odd thing is that I can reproduce the issue using a small python
> snippet, but not through Sphinx.

Your original error message suggests your Sphinx actually uses python
3. Can you check that? The clue is that it's the *decode* that fails.

Does the below patch help? It avoids the implicit ascii decoding due to
universal_newlines=True and your LANG setting, and does explicit utf-8
decoding instead.

Fingers crossed.

BR,
Jani.


diff --git a/Documentation/sphinx/kerneldoc.py b/Documentation/sphinx/kerneldoc.py
index d15e07f36881..39aa9e8697cc 100644
--- a/Documentation/sphinx/kerneldoc.py
+++ b/Documentation/sphinx/kerneldoc.py
@@ -27,6 +27,7 @@
 # Please make sure this works on both python2 and python3.
 #
 
+import codecs
 import os
 import subprocess
 import sys
@@ -88,13 +89,10 @@ class KernelDocDirective(Directive):
         try:
             env.app.verbose('calling kernel-doc \'%s\'' % (" ".join(cmd)))
 
-            p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, universal_newlines=True)
+            p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
             out, err = p.communicate()
 
-            # python2 needs conversion to unicode.
-            # python3 with universal_newlines=True returns strings.
-            if sys.version_info.major < 3:
-                out, err = unicode(out, 'utf-8'), unicode(err, 'utf-8')
+            out, err = codecs.decode(out, 'utf-8'), codecs.decode(err, 'utf-8')
 
             if p.returncode != 0:
                 sys.stderr.write(err)



-- 
Jani Nikula, Intel Open Source Technology Center
