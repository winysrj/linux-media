Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtpauth01.prod.mesa1.secureserver.net ([64.202.165.181]:55357
	"HELO smtpauth01.prod.mesa1.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751848AbZC1XH2 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 28 Mar 2009 19:07:28 -0400
Subject: read() behavior
From: Steve Harrington <Steve@Emel-Harrington.net>
Reply-To: Steve@Emel-Harrington.net
To: linux-media@vger.kernel.org
Content-Type: text/plain
Date: Sat, 28 Mar 2009 16:00:45 -0700
Message-Id: <1238281245.2166.11.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

In general read(2) is not guaranteed to return a complete record.  For
section reads from the demux device the amount of data returned will
almost certainly be less than requested. I've never seen a section
longer than a single TS packet and the recommended length for a read is
4096 bytes.  The questions: are the v4l-dvb drivers guaranteed to return
a complete section for each read?  If not, is there a preferred method
to reassemble split sections? 

