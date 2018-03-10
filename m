Return-path: <linux-media-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22179 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751057AbeCJWve (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Sat, 10 Mar 2018 17:51:34 -0500
Date: Sun, 11 Mar 2018 06:51:08 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
Subject: htmldocs: include/linux/crypto.h:469: warning: Function parameter or
 member 'cra_u.ablkcipher' not described in 'crypto_alg'
Message-ID: <201803110656.S8cRyqEr%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="EeQfGwPcQSOJBaQU"
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


--EeQfGwPcQSOJBaQU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   3266b5bd97eaa72793df0b6e5a106c69ccc166c4
commit: 151c468b44a89a9f3173ab8575690014b7249893 scripts: kernel-doc: print the declaration name on warnings
date:   3 months ago
reproduce: make htmldocs

All warnings (new ones prefixed by >>):

   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   include/crypto/hash.h:89: warning: duplicate section name 'Note'
   include/crypto/hash.h:95: warning: duplicate section name 'Note'
   include/crypto/hash.h:102: warning: duplicate section name 'Note'
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   include/crypto/hash.h:89: warning: duplicate section name 'Note'
   include/crypto/hash.h:95: warning: duplicate section name 'Note'
   include/crypto/hash.h:102: warning: duplicate section name 'Note'
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   include/crypto/hash.h:89: warning: duplicate section name 'Note'
   include/crypto/hash.h:95: warning: duplicate section name 'Note'
   include/crypto/hash.h:102: warning: duplicate section name 'Note'
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   include/crypto/hash.h:89: warning: duplicate section name 'Note'
   include/crypto/hash.h:95: warning: duplicate section name 'Note'
   include/crypto/hash.h:102: warning: duplicate section name 'Note'
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   include/crypto/hash.h:89: warning: duplicate section name 'Note'
   include/crypto/hash.h:95: warning: duplicate section name 'Note'
   include/crypto/hash.h:102: warning: duplicate section name 'Note'
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   include/crypto/hash.h:89: warning: duplicate section name 'Note'
   include/crypto/hash.h:95: warning: duplicate section name 'Note'
   include/crypto/hash.h:102: warning: duplicate section name 'Note'
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   include/crypto/hash.h:89: warning: duplicate section name 'Note'
   include/crypto/hash.h:95: warning: duplicate section name 'Note'
   include/crypto/hash.h:102: warning: duplicate section name 'Note'
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   include/crypto/hash.h:89: warning: duplicate section name 'Note'
   include/crypto/hash.h:95: warning: duplicate section name 'Note'
   include/crypto/hash.h:102: warning: duplicate section name 'Note'
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
>> include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.ablkcipher' not described in 'crypto_alg'
>> include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.blkcipher' not described in 'crypto_alg'
>> include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.cipher' not described in 'crypto_alg'
>> include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.compress' not described in 'crypto_alg'
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
>> include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.ablkcipher' not described in 'crypto_alg'
>> include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.blkcipher' not described in 'crypto_alg'
>> include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.cipher' not described in 'crypto_alg'
>> include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.compress' not described in 'crypto_alg'
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
>> include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.ablkcipher' not described in 'crypto_alg'
>> include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.blkcipher' not described in 'crypto_alg'
>> include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.cipher' not described in 'crypto_alg'
>> include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.compress' not described in 'crypto_alg'
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
>> include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.ablkcipher' not described in 'crypto_alg'
>> include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.blkcipher' not described in 'crypto_alg'
>> include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.cipher' not described in 'crypto_alg'
>> include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.compress' not described in 'crypto_alg'
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.
>> include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.ablkcipher' not described in 'crypto_alg'
>> include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.blkcipher' not described in 'crypto_alg'
>> include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.cipher' not described in 'crypto_alg'
>> include/linux/crypto.h:469: warning: Function parameter or member 'cra_u.compress' not described in 'crypto_alg'
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1036.
   Unescaped left brace in regex is deprecated here (and will be fatal in Perl 5.30), passed through in regex; marked by <-- HERE in m/(struct|union)([^{};]+){ <-- HERE ([^{}]*)}([^{}\;]*)\;/ at scripts/kernel-doc line 1058.

vim +469 include/linux/crypto.h

^1da177e4 Linus Torvalds  2005-04-16  364  
0d7f488f0 Stephan Mueller 2014-11-12  365  /**
0d7f488f0 Stephan Mueller 2014-11-12  366   * struct crypto_alg - definition of a cryptograpic cipher algorithm
0d7f488f0 Stephan Mueller 2014-11-12  367   * @cra_flags: Flags describing this transformation. See include/linux/crypto.h
0d7f488f0 Stephan Mueller 2014-11-12  368   *	       CRYPTO_ALG_* flags for the flags which go in here. Those are
0d7f488f0 Stephan Mueller 2014-11-12  369   *	       used for fine-tuning the description of the transformation
0d7f488f0 Stephan Mueller 2014-11-12  370   *	       algorithm.
0d7f488f0 Stephan Mueller 2014-11-12  371   * @cra_blocksize: Minimum block size of this transformation. The size in bytes
0d7f488f0 Stephan Mueller 2014-11-12  372   *		   of the smallest possible unit which can be transformed with
0d7f488f0 Stephan Mueller 2014-11-12  373   *		   this algorithm. The users must respect this value.
0d7f488f0 Stephan Mueller 2014-11-12  374   *		   In case of HASH transformation, it is possible for a smaller
0d7f488f0 Stephan Mueller 2014-11-12  375   *		   block than @cra_blocksize to be passed to the crypto API for
0d7f488f0 Stephan Mueller 2014-11-12  376   *		   transformation, in case of any other transformation type, an
0d7f488f0 Stephan Mueller 2014-11-12  377   * 		   error will be returned upon any attempt to transform smaller
0d7f488f0 Stephan Mueller 2014-11-12  378   *		   than @cra_blocksize chunks.
0d7f488f0 Stephan Mueller 2014-11-12  379   * @cra_ctxsize: Size of the operational context of the transformation. This
0d7f488f0 Stephan Mueller 2014-11-12  380   *		 value informs the kernel crypto API about the memory size
0d7f488f0 Stephan Mueller 2014-11-12  381   *		 needed to be allocated for the transformation context.
0d7f488f0 Stephan Mueller 2014-11-12  382   * @cra_alignmask: Alignment mask for the input and output data buffer. The data
0d7f488f0 Stephan Mueller 2014-11-12  383   *		   buffer containing the input data for the algorithm must be
0d7f488f0 Stephan Mueller 2014-11-12  384   *		   aligned to this alignment mask. The data buffer for the
0d7f488f0 Stephan Mueller 2014-11-12  385   *		   output data must be aligned to this alignment mask. Note that
0d7f488f0 Stephan Mueller 2014-11-12  386   *		   the Crypto API will do the re-alignment in software, but
0d7f488f0 Stephan Mueller 2014-11-12  387   *		   only under special conditions and there is a performance hit.
0d7f488f0 Stephan Mueller 2014-11-12  388   *		   The re-alignment happens at these occasions for different
0d7f488f0 Stephan Mueller 2014-11-12  389   *		   @cra_u types: cipher -- For both input data and output data
0d7f488f0 Stephan Mueller 2014-11-12  390   *		   buffer; ahash -- For output hash destination buf; shash --
0d7f488f0 Stephan Mueller 2014-11-12  391   *		   For output hash destination buf.
0d7f488f0 Stephan Mueller 2014-11-12  392   *		   This is needed on hardware which is flawed by design and
0d7f488f0 Stephan Mueller 2014-11-12  393   *		   cannot pick data from arbitrary addresses.
0d7f488f0 Stephan Mueller 2014-11-12  394   * @cra_priority: Priority of this transformation implementation. In case
0d7f488f0 Stephan Mueller 2014-11-12  395   *		  multiple transformations with same @cra_name are available to
0d7f488f0 Stephan Mueller 2014-11-12  396   *		  the Crypto API, the kernel will use the one with highest
0d7f488f0 Stephan Mueller 2014-11-12  397   *		  @cra_priority.
0d7f488f0 Stephan Mueller 2014-11-12  398   * @cra_name: Generic name (usable by multiple implementations) of the
0d7f488f0 Stephan Mueller 2014-11-12  399   *	      transformation algorithm. This is the name of the transformation
0d7f488f0 Stephan Mueller 2014-11-12  400   *	      itself. This field is used by the kernel when looking up the
0d7f488f0 Stephan Mueller 2014-11-12  401   *	      providers of particular transformation.
0d7f488f0 Stephan Mueller 2014-11-12  402   * @cra_driver_name: Unique name of the transformation provider. This is the
0d7f488f0 Stephan Mueller 2014-11-12  403   *		     name of the provider of the transformation. This can be any
0d7f488f0 Stephan Mueller 2014-11-12  404   *		     arbitrary value, but in the usual case, this contains the
0d7f488f0 Stephan Mueller 2014-11-12  405   *		     name of the chip or provider and the name of the
0d7f488f0 Stephan Mueller 2014-11-12  406   *		     transformation algorithm.
0d7f488f0 Stephan Mueller 2014-11-12  407   * @cra_type: Type of the cryptographic transformation. This is a pointer to
0d7f488f0 Stephan Mueller 2014-11-12  408   *	      struct crypto_type, which implements callbacks common for all
12f7c14aa Masanari Iida   2015-06-04  409   *	      transformation types. There are multiple options:
0d7f488f0 Stephan Mueller 2014-11-12  410   *	      &crypto_blkcipher_type, &crypto_ablkcipher_type,
b0d955ba4 Herbert Xu      2015-08-14  411   *	      &crypto_ahash_type, &crypto_rng_type.
0d7f488f0 Stephan Mueller 2014-11-12  412   *	      This field might be empty. In that case, there are no common
0d7f488f0 Stephan Mueller 2014-11-12  413   *	      callbacks. This is the case for: cipher, compress, shash.
0d7f488f0 Stephan Mueller 2014-11-12  414   * @cra_u: Callbacks implementing the transformation. This is a union of
0d7f488f0 Stephan Mueller 2014-11-12  415   *	   multiple structures. Depending on the type of transformation selected
0d7f488f0 Stephan Mueller 2014-11-12  416   *	   by @cra_type and @cra_flags above, the associated structure must be
0d7f488f0 Stephan Mueller 2014-11-12  417   *	   filled with callbacks. This field might be empty. This is the case
0d7f488f0 Stephan Mueller 2014-11-12  418   *	   for ahash, shash.
0d7f488f0 Stephan Mueller 2014-11-12  419   * @cra_init: Initialize the cryptographic transformation object. This function
0d7f488f0 Stephan Mueller 2014-11-12  420   *	      is used to initialize the cryptographic transformation object.
0d7f488f0 Stephan Mueller 2014-11-12  421   *	      This function is called only once at the instantiation time, right
0d7f488f0 Stephan Mueller 2014-11-12  422   *	      after the transformation context was allocated. In case the
0d7f488f0 Stephan Mueller 2014-11-12  423   *	      cryptographic hardware has some special requirements which need to
0d7f488f0 Stephan Mueller 2014-11-12  424   *	      be handled by software, this function shall check for the precise
0d7f488f0 Stephan Mueller 2014-11-12  425   *	      requirement of the transformation and put any software fallbacks
0d7f488f0 Stephan Mueller 2014-11-12  426   *	      in place.
0d7f488f0 Stephan Mueller 2014-11-12  427   * @cra_exit: Deinitialize the cryptographic transformation object. This is a
0d7f488f0 Stephan Mueller 2014-11-12  428   *	      counterpart to @cra_init, used to remove various changes set in
0d7f488f0 Stephan Mueller 2014-11-12  429   *	      @cra_init.
0d7f488f0 Stephan Mueller 2014-11-12  430   * @cra_module: Owner of this transformation implementation. Set to THIS_MODULE
0d7f488f0 Stephan Mueller 2014-11-12  431   * @cra_list: internally used
0d7f488f0 Stephan Mueller 2014-11-12  432   * @cra_users: internally used
0d7f488f0 Stephan Mueller 2014-11-12  433   * @cra_refcnt: internally used
0d7f488f0 Stephan Mueller 2014-11-12  434   * @cra_destroy: internally used
0d7f488f0 Stephan Mueller 2014-11-12  435   *
0d7f488f0 Stephan Mueller 2014-11-12  436   * The struct crypto_alg describes a generic Crypto API algorithm and is common
0d7f488f0 Stephan Mueller 2014-11-12  437   * for all of the transformations. Any variable not documented here shall not
0d7f488f0 Stephan Mueller 2014-11-12  438   * be used by a cipher implementation as it is internal to the Crypto API.
0d7f488f0 Stephan Mueller 2014-11-12  439   */
^1da177e4 Linus Torvalds  2005-04-16  440  struct crypto_alg {
^1da177e4 Linus Torvalds  2005-04-16  441  	struct list_head cra_list;
6bfd48096 Herbert Xu      2006-09-21  442  	struct list_head cra_users;
6bfd48096 Herbert Xu      2006-09-21  443  
^1da177e4 Linus Torvalds  2005-04-16  444  	u32 cra_flags;
^1da177e4 Linus Torvalds  2005-04-16  445  	unsigned int cra_blocksize;
^1da177e4 Linus Torvalds  2005-04-16  446  	unsigned int cra_ctxsize;
954773779 Herbert Xu      2005-07-06  447  	unsigned int cra_alignmask;
5cb1454b8 Herbert Xu      2005-11-05  448  
5cb1454b8 Herbert Xu      2005-11-05  449  	int cra_priority;
6521f3027 Herbert Xu      2006-08-06  450  	atomic_t cra_refcnt;
5cb1454b8 Herbert Xu      2005-11-05  451  
d913ea0d6 Herbert Xu      2006-05-21  452  	char cra_name[CRYPTO_MAX_ALG_NAME];
d913ea0d6 Herbert Xu      2006-05-21  453  	char cra_driver_name[CRYPTO_MAX_ALG_NAME];
^1da177e4 Linus Torvalds  2005-04-16  454  
e853c3cfa Herbert Xu      2006-08-22  455  	const struct crypto_type *cra_type;
e853c3cfa Herbert Xu      2006-08-22  456  
^1da177e4 Linus Torvalds  2005-04-16  457  	union {
b5b7f0886 Herbert Xu      2007-04-16  458  		struct ablkcipher_alg ablkcipher;
5cde0af2a Herbert Xu      2006-08-22  459  		struct blkcipher_alg blkcipher;
^1da177e4 Linus Torvalds  2005-04-16  460  		struct cipher_alg cipher;
^1da177e4 Linus Torvalds  2005-04-16  461  		struct compress_alg compress;
^1da177e4 Linus Torvalds  2005-04-16  462  	} cra_u;
^1da177e4 Linus Torvalds  2005-04-16  463  
c7fc05992 Herbert Xu      2006-05-24  464  	int (*cra_init)(struct crypto_tfm *tfm);
c7fc05992 Herbert Xu      2006-05-24  465  	void (*cra_exit)(struct crypto_tfm *tfm);
6521f3027 Herbert Xu      2006-08-06  466  	void (*cra_destroy)(struct crypto_alg *alg);
c7fc05992 Herbert Xu      2006-05-24  467  	
^1da177e4 Linus Torvalds  2005-04-16  468  	struct module *cra_module;
edf18b910 Herbert Xu      2015-06-18 @469  } CRYPTO_MINALIGN_ATTR;
^1da177e4 Linus Torvalds  2005-04-16  470  

:::::: The code at line 469 was first introduced by commit
:::::: edf18b9108f5025f9e83b2c167c9122954acbc62 crypto: api - Add CRYPTO_MINALIGN_ATTR to struct crypto_alg

:::::: TO: Herbert Xu <herbert@gondor.apana.org.au>
:::::: CC: Herbert Xu <herbert@gondor.apana.org.au>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--EeQfGwPcQSOJBaQU
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--EeQfGwPcQSOJBaQU--
