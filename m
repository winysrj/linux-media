Return-path: <linux-media-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([192.94.94.40]:60958 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756760AbZKMWgE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 13 Nov 2009 17:36:04 -0500
Received: from dlep34.itg.ti.com ([157.170.170.115])
	by arroyo.ext.ti.com (8.13.7/8.13.7) with ESMTP id nADMa9b7002907
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-media@vger.kernel.org>; Fri, 13 Nov 2009 16:36:09 -0600
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep34.itg.ti.com (8.13.7/8.13.7) with ESMTP id nADMa9R8013940
	for <linux-media@vger.kernel.org>; Fri, 13 Nov 2009 16:36:09 -0600 (CST)
Received: from dlee75.ent.ti.com (localhost [127.0.0.1])
	by dlep26.itg.ti.com (8.13.8/8.13.8) with ESMTP id nADMa9dR008282
	for <linux-media@vger.kernel.org>; Fri, 13 Nov 2009 16:36:09 -0600 (CST)
From: "Karicheri, Muralidharan" <m-karicheri2@ti.com>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Fri, 13 Nov 2009 16:36:07 -0600
Subject: Documentation - How do I add v4l2 documentation under media-specs ?
Message-ID: <A69FA2915331DC488A831521EAE36FE4015593740C@dlee06.ent.ti.com>
Content-Language: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

I need to update the V4l2 documentation for the video timing API. I have got the relevant tree downloaded and did make media-spec

I got the media.html under media-specs/media-single/media.html after the build.

When I open this file in a web browser, I see the document with a Table of
contents and links. I need to add a sections for the video timing API, which involves adding two sections, one on DV_PRESET and other on DV_TIMING. How do a developer typically add documentation? Do I need to use a xml editor?
I am not that familiar with xml/html notations (except for the simple tags)
and wondering how I can update the documents. Any help will be appreciated.

Murali Karicheri
Software Design Engineer
Texas Instruments Inc.
Germantown, MD 20874
email: m-karicheri2@ti.com

