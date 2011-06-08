Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:6444 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754146Ab1FHBqO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 21:46:14 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p581kENt006778
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:46:14 -0400
Received: from pedra (vpn-236-210.phx2.redhat.com [10.3.236.210])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p581jncH007506
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:46:13 -0400
Date: Tue, 7 Jun 2011 22:45:42 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 00/15] DVB Frontend Documentation patches
Message-ID: <20110607224542.597d46bc@pedra>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

This series of patches updates the DVB v5 documentation, sinchronizing
the current implementation with the API spec.
Among other things, it:
	- adds a logic that discovers API gaps between the header
	  file and the API specs;
	- adds/fixes the DVB S2API (DVBv5) additions;
	- adds the FE_ATSC frontend descriptions (both v3 and v5);
	- adds a relation of DVBv5 parameters for usage for each
	  supported delivery system.

The API updates were made at the best effort basis, by doing a sort
of "reverse engineering" approach, e. g., by looking at the code
and trying to figure out what changed, why and how. Due to that,
I bet people will find errors on it. Also, English is not my native
language, and I didn't have time for doing a language review.

so I'm sure that language/style/typo fixes are needed.

So, I'd like to encourage people to carefully read the docs and
send us patches with fixes.

Anyway, as the situation after those patches are better than before them,
I'm pushing it to the main repository. This helps to review, as the
linuxtv scripts will re-format the DocBook into html.

Mauro Carvalho Chehab (15):
  [media] DocBook/Makefile: add references for several dvb structures
  [media] DocBook/frontend.xml: Better document fe_type_t
  [media] DocBook/frontend.xml: Link DVB S2API parameters
  [media] DocBook/frontend.xml: Correlate dvb delivery systems
  [media] DocBook/frontend.xml: add references for some missing info
  [media] DocBook/frontend.xml: Better describe the frontend parameters
  [media] DocBook/dvbproperty.xml: Document the remaining S2API parameters
  [media] DocBook/dvbproperty.xml: Use links for all parameters
  [media] DocBook/dvbproperty.xml: Reorganize the parameters
  [media] DocBook/frontend.xml: Recomend the usage of the new API
  [media] DocBook/dvbproperty.xml: Document the terrestrial delivery systems
  [media] DocBook: Finish synchronizing the frontend API
  [media] DocBook/dvbproperty.xml: Add Cable standards
  [media] DocBook/dvbproperty.xml: Add ATSC standard
  [media] DocBook/dvbproperty.xml: Add Satellite standards

 Documentation/DocBook/media/Makefile            |   17 +-
 Documentation/DocBook/media/dvb/dvbproperty.xml |  965 +++++++++++++++--------
 Documentation/DocBook/media/dvb/frontend.xml    |  285 +++++---
 3 files changed, 833 insertions(+), 434 deletions(-)

