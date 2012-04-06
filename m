Return-path: <linux-media-owner@vger.kernel.org>
Received: from nm17.bullet.mail.ird.yahoo.com ([77.238.189.70]:40313 "HELO
	nm17.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754840Ab2DFO7M (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 6 Apr 2012 10:59:12 -0400
Message-ID: <4F7F04B9.1040802@yahoo.com>
Date: Fri, 06 Apr 2012 15:59:05 +0100
From: Chris Rankin <rankincj@yahoo.com>
MIME-Version: 1.0
To: crope@iki.fi
CC: linux-media@vger.kernel.org
Subject: Re: DVB ioctl FE_GET_EVENT behaviour broken in 3.3
References: <4F7ED7E9.203@iki.fi>
In-Reply-To: <4F7ED7E9.203@iki.fi>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

The problem is that the following line was deleted from the FE_SET_FRONTEND 
ioctl logic:

         fepriv->parameters_out = fepriv->parameters_in;

The following dirty little patch restores the correct behaviour:

--- dvb_frontend.c.orig	2012-04-06 13:28:43.000000000 +0100
+++ dvb_frontend.c	2012-04-06 15:42:04.000000000 +0100
@@ -1877,6 +1877,8 @@
  	if (c->hierarchy == HIERARCHY_NONE && c->code_rate_LP == FEC_NONE)
  		c->code_rate_LP = FEC_AUTO;

+	fepriv->parameters_out.frequency = c->frequency;
+
  	/* get frontend-specific tuning settings */
  	memset(&fetunesettings, 0, sizeof(struct dvb_frontend_tune_settings));
  	if (fe->ops.get_tune_settings && (fe->ops.get_tune_settings(fe, 
&fetunesettings) == 0)) {

I'm hoping that someone out there who understands the new logic better than I 
can provide a better patch.

Cheers,
Chris
