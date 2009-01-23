Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx38.mail.ru ([194.67.23.16]:54123 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755654AbZAWVgK (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Fri, 23 Jan 2009 16:36:10 -0500
Date: Sat, 24 Jan 2009 00:44:35 +0300
From: Goga777 <goga777@bk.ru>
To: linux-dvb@linuxtv.org
Cc: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] cx24116 & roll-off factor = auto
Message-ID: <20090124004435.0c110182@bk.ru>
In-Reply-To: <c74595dc0901231151iafa6b15kd3c0949e0ed86668@mail.gmail.com>
References: <20090123205854.45e40dd0@bk.ru>
	<200901231959.49629.hftom@free.fr>
	<20090123224924.62a48791@bk.ru>
	<c74595dc0901231151iafa6b15kd3c0949e0ed86668@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> For example, DVB-S uses only rolloff = 0.35, so if the driver knows that the
> chip can't accept auto value, it should use 0.35 value by default in that
> case.

good idea. Anybody against ? 

Goga
