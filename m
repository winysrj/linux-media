Return-path: <linux-media-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:59442 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521Ab1L0KfL (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Dec 2011 05:35:11 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gldv-linux-media@m.gmane.org>)
	id 1RfUNB-00051t-OW
	for linux-media@vger.kernel.org; Tue, 27 Dec 2011 11:35:10 +0100
Received: from 141.201.123.28 ([141.201.123.28])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 27 Dec 2011 11:35:09 +0100
Received: from cpraehaus by 141.201.123.28 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-media@vger.kernel.org>; Tue, 27 Dec 2011 11:35:09 +0100
To: linux-media@vger.kernel.org
From: Christian =?utf-8?b?UHLDpGhhdXNlcg==?= <cpraehaus@cosy.sbg.ac.at>
Subject: Re: DVB-S2 multistream support
Date: Tue, 27 Dec 2011 10:12:59 +0000 (UTC)
Message-ID: <loom.20111227T105753-96@post.gmane.org>
References: <4EF67721.9050102@unixsol.org> <4EF6DD91.2030800@iki.fi> <4EF6F84C.3000307@redhat.com> <CAF0Ff2kkFJYLUjVdmV9d9aWTsi-2ZHHEEjLrVSTCUnP+VTyxRg@mail.gmail.com> <4EF7066C.4070806@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> 
> Yes, I'm meaning something like what it was described there. I think
> that the code written by Christian were never submitted upstream.
> 

Hello Mauro,

Konstantin drew my attention to this discussion. Indeed, some time ago I wrote 
a base-band demux for LinuxDVB. It was part of a project to integrate support 
for second-generation IP/DVB encapsulations (GSE). The BB-demux allows to
register filters for different ISIs and data types (raw, generic stream,
transport stream).

I realized that the repo hosted at our University is down. If there is interest,
I can update my patches to the latest LinuxDVB version and we can put them on a 
public repo e.g. at linuxdvb.org.

Kind regards,
Christian.
 





