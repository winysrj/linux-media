Return-path: <mchehab@pedra>
Received: from claranet-outbound-smtp03.uk.clara.net ([195.8.89.36]:57935 "EHLO
	claranet-outbound-smtp03.uk.clara.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751073Ab1ECO0u (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 3 May 2011 10:26:50 -0400
From: Simon Farnsworth <simon.farnsworth@onelan.co.uk>
To: Hans Verkuil <hansverk@cisco.com>
Subject: Re: [git:v4l-dvb/for_v2.6.40] [media] cx18: mmap() support for raw YUV video capture
Date: Tue, 3 May 2011 15:26:41 +0100
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Mauro Carvalho Chehab <mchehab@redhat.com>,
	linux-media@vger.kernel.org, Steven Toth <stoth@kernellabs.com>,
	Andy Walls <awalls@md.metrocast.net>
References: <E1QGwlS-0006ys-15@www.linuxtv.org> <BANLkTinjYo0zW56+vEMDciXkdk9gePOZnQ@mail.gmail.com> <201105031559.52492.hansverk@cisco.com>
In-Reply-To: <201105031559.52492.hansverk@cisco.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105031526.41774.simon.farnsworth@onelan.co.uk>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

On Tuesday 3 May 2011, Hans Verkuil <hansverk@cisco.com> wrote:
> On Tuesday, May 03, 2011 14:49:43 Devin Heitmueller wrote:
> > Asking us to be the "guinea pig" for this new framework just because
> > cx18 is the most recent driver to get a videobuf related patch just
> > isn't appropriate.
> 
> I don't get it.
> 
> What better non-embedded driver to implement vb2 in than one that doesn't
> yet do stream I/O? The risks of breaking anything are much smaller and it
> would be a good 'gentle introduction' to vb2. Also, it prevents the
> unnecessary overhead of having to replace videobuf in the future in cx18.
> 
Just for everyone's information; I've been caught up in other issues here, so 
I'm unlikely to get onto changing videobuf to vb2 in this code in the next 
week or so.

However, if someone else had just enough free time to convert the existing 
patch for me, I can free up enough time to test with our application and with 
GStreamer, to confirm that the conversion works adequately.
-- 
Simon Farnsworth
Software Engineer
ONELAN Limited
http://www.onelan.com/
