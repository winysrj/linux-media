Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46279 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab0FQMpe (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 17 Jun 2010 08:45:34 -0400
Received: by wyf23 with SMTP id 23so82682wyf.19
        for <linux-media@vger.kernel.org>; Thu, 17 Jun 2010 05:45:32 -0700 (PDT)
Message-ID: <4C1A18ED.3060600@gmail.com>
Date: Thu, 17 Jun 2010 13:45:33 +0100
From: George Helyar <ghelyar@gmail.com>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Latest DVB documentation and examples
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I have version 5.1 of the DVB API

#define DVB_API_VERSION 5
#define DVB_API_VERSION_MINOR 1

However, I could only find documentation and examples on the web for 
version 3.

This uses devices that I don't have. Here's what I do have:

/dev/dvb/adapter0/demux0
/dev/dvb/adapter0/dvr0
/dev/dvb/adapter0/frontend0
/dev/dvb/adapter0/net0


Is there any newer documentation out there? In particular I want to play 
with DVB-T in the UK (Freeview).

I'm running Debian Squeeze amd64.
