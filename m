Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:30667 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751108AbZLXCR2 (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 21:17:28 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id nBO2HSOn008676
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Wed, 23 Dec 2009 21:17:28 -0500
Received: from gaivota.chehab.org (vpn-8-183.rdu.redhat.com [10.11.8.183])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id nBO2HOZG006619
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Wed, 23 Dec 2009 21:17:27 -0500
Message-ID: <4B32CF33.3030201@redhat.com>
Date: Thu, 24 Dec 2009 00:17:23 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [RFC] dvb-apps ported for ISDB-T
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I wrote several patches those days in order to allow dvb-apps to properly
parse ISDB-T channel.conf.

On ISDB-T, there are several new parameters, so the parsing is more complex
than all the other currently supported video standards.

I've added the changes at:

http://linuxtv.org/hg/~mchehab/dvb-apps-isdbt/

I've merged there Patrick's dvb-apps-isdbt tree.

While there, I fixed a few bugs I noticed on the parser and converted it
to work with the DVB API v5 headers that are bundled together with dvb-apps.
This helps to avoid adding lots of extra #if DVB_ABI_VERSION tests. The ones
there can now be removed.

TODO:
=====

The new ISDB-T parameters are parsed, but I haven't add yet a code to make
them to be used;

There are 3 optional parameters with ISDB-T, related to 1seg/3seg: the
segment parameters. Currently, the parser will fail if those parameters are found.

gnutv is still reporting ISDB-T as "DVB-T".

needs to review the other applications.

Please review. If everything is right, I intend to commit it likely next week at
dvb-apps.

Cheers,
Mauro.
