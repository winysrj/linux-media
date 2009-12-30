Return-path: <linux-media-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:58168 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751876AbZL3RUT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 30 Dec 2009 12:20:19 -0500
Received: from dlep36.itg.ti.com ([157.170.170.91])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id nBUHKI2e006488
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 30 Dec 2009 11:20:18 -0600
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep36.itg.ti.com (8.13.8/8.13.8) with ESMTP id nBUHKIwn017158
	for <linux-media@vger.kernel.org>; Wed, 30 Dec 2009 11:20:18 -0600 (CST)
Received: from dlee74.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id nBUHKIlE003138
	for <linux-media@vger.kernel.org>; Wed, 30 Dec 2009 11:20:18 -0600 (CST)
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Wed, 30 Dec 2009 11:20:16 -0600
Subject: help on mercurial
Message-ID: <A69FA2915331DC488A831521EAE36FE40162C22C53@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I am trying to build and install mercurial 1.4 on my Redhat Linux machine. I could build and install python. When building mercurial, I got following 

error log:-
make all
=> error log...
python setup.py build
  File "setup.py", line 147
    for l in open('.hg_archival.txt'))
      ^
SyntaxError: invalid syntax.

I am trying to learn mercurial for hosting my own hg tree and ended up here :(. 

Any help will be appreciated.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
phone: 301-407-9583
email: m-karicheri2@ti.com

