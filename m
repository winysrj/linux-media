Return-path: <linux-media-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:45900 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752071AbcF1Lsj (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Jun 2016 07:48:39 -0400
Date: Tue, 28 Jun 2016 14:48:09 +0300
From: Andrey Utkin <andrey_utkin@fastmail.com>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Ismael Luceno <ismael@iodev.co.uk>, linux-media@vger.kernel.org,
	Andrey Utkin <andrey.utkin@corp.bluecherry.net>
Subject: Re: [PATCH v2 1/2] solo6x10: Set FRAME_BUF_SIZE to 200KB
Message-ID: <20160628114809.GF31802@acer>
References: <1462378881-16625-1-git-send-email-ismael@iodev.co.uk>
 <33cd3138-6adc-d9c4-a9b0-bfb5f0445088@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33cd3138-6adc-d9c4-a9b0-bfb5f0445088@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Mon, Jun 27, 2016 at 11:12:42AM +0200, Hans Verkuil wrote:
> Andrey,
> 
> Since you are the original author, can you give me your Signed-off-by line?

No, as increasing buffer size by few kilobytes doesn't change anything. I've
increased it from 200 to 204, then found new occurances of the issue,
then increased it again and again by few kilobytes. Then I got that this
is not a (nice) solution, and have never came back to this. Maybe
doubling current buffer size would make users forget about this, but I'm
not sure maintainers would be glad with such patch.
