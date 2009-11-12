Return-path: <linux-media-owner@vger.kernel.org>
Received: from killer.cirr.com ([192.67.63.5]:65142 "EHLO killer.cirr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091AbZKLD2G (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Wed, 11 Nov 2009 22:28:06 -0500
Received: from afc by tashi.lonestar.org with local (Exim 4.69)
	(envelope-from <afc@shibaya.lonestar.org>)
	id 1N8QAx-0004s3-Ra
	for linux-media@vger.kernel.org; Wed, 11 Nov 2009 22:16:47 -0500
Date: Wed, 11 Nov 2009 22:16:47 -0500
From: "A. F. Cano" <afc@shibaya.lonestar.org>
To: linux-media@vger.kernel.org
Subject: Procmail won't route this list (linux-media) correctly.  Help!
Message-ID: <20091112031647.GA17951@shibaya.lonestar.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

This is the only mailing list that I receive that procmail doesn't
handle properly.  All the others get sent to their own mailboxes.
What is so strange about the headers of this list?

This is the procmail recipe I use: (I've tried routing this list's
email through all kinds of headers I have observed in the emails.
In all the other lists I get, the ^TO header is enough)

:0:
* ^TO(linux-dvb@linuxtv.org|linux-media@vger.kernel.org) |\
  ^Reply-To(linux-media@vger.kernel.org) |\
  ^X-Mailing-List(linux-media@vger.kernel.org) |\
  ^CC(linux-media@vger.kernel.org) |\
  ^LIST-ID(linux-media.vger.kernel.org)
$LINUXDVBFOLDER

Note: I'm trying to put the linux-dvb and linux-media mail in the
same folder.  The same scheme works fine for other lists.

Help!

Augustine

