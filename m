Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56199 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756391AbZFJXX6 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 19:23:58 -0400
Date: Wed, 10 Jun 2009 16:23:44 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexey Klimov <klimov.linux@gmail.com>
Cc: mchehab@infradead.org, linux-media@vger.kernel.org,
	abogani@texware.it
Subject: Re: [patch 1/6] radio-mr800.c: missing mutex include
Message-Id: <20090610162344.3f29de3c.akpm@linux-foundation.org>
In-Reply-To: <208cbae30906101621v6ba12fbbsf29c0d6ec35768d8@mail.gmail.com>
References: <200906101944.n5AJiIKQ031735@imap1.linux-foundation.org>
	<208cbae30906101621v6ba12fbbsf29c0d6ec35768d8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, 11 Jun 2009 03:21:36 +0400 Alexey Klimov <klimov.linux@gmail.com> wrote:

> On Wed, Jun 10, 2009 at 11:44 PM, <akpm@linux-foundation.org> wrote:
> > From: Alessio Igor Bogani <abogani@texware.it>
> >
> > radio-mr800.c uses struct mutex, so while <linux/mutex.h> seems to be
> > pulled in indirectly by one of the headers it already includes, the right
> > thing is to include it directly.
> 
> It was already applied to v4l-dvb tree (and probably to v4l git tree).

It isn't in today's linux-next.
