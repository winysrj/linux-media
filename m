Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:59319 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab3GCGiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Wed, 3 Jul 2013 02:38:11 -0400
Received: by mail-ie0-f175.google.com with SMTP id a13so13412350iee.6
        for <linux-media@vger.kernel.org>; Tue, 02 Jul 2013 23:38:10 -0700 (PDT)
Date: Tue, 02 Jul 2013 13:55:53 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] DocBook: upgrade media_api DocBook version to 4.2
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: linux-media@vger.kernel.org, Andrzej Hajda <a.hajda@samsung.com>,
	linux-doc@vger.kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
	Sylwester Nawrocki <s.nawrocki@samsung.com>,
	Kyungmin Park <kyungmin.park@samsung.com>
References: <1372412060-6989-1-git-send-email-a.hajda@samsung.com>
In-Reply-To: <1372412060-6989-1-git-send-email-a.hajda@samsung.com> (from
	a.hajda@samsung.com on Fri Jun 28 04:34:20 2013)
Message-Id: <1372791353.5019.12@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 06/28/2013 04:34:20 AM, Andrzej Hajda wrote:
> Fixes the last three errors of media_api DocBook validatation:
> # make DOCBOOKS=media_api.xml XMLTOFLAGS='-m  
> Documentation/DocBook/stylesheet.xsl' htmldocs
> (...)
> media_api.xml:414: element imagedata: validity error : Value "SVG"  
> for attribute format of imagedata is not among the enumerated set
> media_api.xml:432: element imagedata: validity error : Value "SVG"  
> for attribute format of imagedata is not among the enumerated set
> media_api.xml:452: element imagedata: validity error : Value "SVG"  
> for attribute format of imagedata is not among the enumerated set
> (...)
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Rob Landley <rob@landley.net>

Please send through trivial@kernel.org

Rob