Return-path: <linux-media-owner@vger.kernel.org>
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33320 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754865Ab2CZUJZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 26 Mar 2012 16:09:25 -0400
Message-ID: <4F70CCF3.4000000@kc.rr.com>
Date: Mon, 26 Mar 2012 15:09:23 -0500
From: Joe Henley <joehenley@kc.rr.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re:  Cannot compile media_build from git sources
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Bogus,

This is the same problem I wrote about on March 21, 2012.  I have 
received no reply so far.

You can try to work around the problem as I did:
-- This assumes you don't need radio-rtrack2.
-- Look at the build command.  Near the end are two "make" commands. 
Comment out the last one.
-- Run the resulting "build".  Then go into ../media_build/v4l/.config 
Set the "radio-rtrack2" to "n" (from "m").
-- Then go back to the directory which has the "build" program and just 
run "make" ...... if all runs OK, then run "make install."

Good luck!

Joe Henley
