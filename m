Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38915 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab1I3Rep (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 30 Sep 2011 13:34:45 -0400
Received: by yxl31 with SMTP id 31so1762522yxl.19
        for <linux-media@vger.kernel.org>; Fri, 30 Sep 2011 10:34:44 -0700 (PDT)
Message-ID: <e9f9d962fccf0ef7c4bddd24ed065c8c.squirrel@localhost>
In-Reply-To: <20110930080609.GD2284@localhost2.local>
References: <20110929224418.GD2824@localhost2.local>
    <4e856d27.92d1e30a.6587.13f8@mx.google.com>
    <20110930080609.GD2284@localhost2.local>
Date: Fri, 30 Sep 2011 12:34:41 -0500
Subject: Re: dvbscan output Channel Number into final stdout?
From: david.hagood@gmail.com
To: "Roger" <rogerx.oss@gmail.com>
Cc: unlisted-recipients:; ""@Deathwish.hagood.sktc.net,
	"no To-header on input"
	<"@yx-in-f108.1e100.net"@Deathwish.hagood.sktc.net>,
	linux-media@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Even that won't always save you. In my area, we have 2 distinct signals,
both identifying themselves as "KAKE-DT" on virtual channel 10.1, so even
that isn't guaranteed to be unique.


