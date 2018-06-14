Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:41892 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755092AbeFNN3K (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 14 Jun 2018 09:29:10 -0400
Date: Thu, 14 Jun 2018 06:29:05 -0700
From: Matthew Wilcox <willy@infradead.org>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Gustavo Padovan <gustavo@padovan.org>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        David Airlie <airlied@linux.ie>,
        Davidlohr Bueso <dave@stgolabs.net>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Philippe Ombredanne <pombredanne@nexb.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-doc@vger.kernel.org, linux-media@vger.kernel.org,
        linaro-mm-sig@lists.linaro.org
Subject: Re: [PATCH v2 1/2] locking: Implement an algorithm choice for
 Wound-Wait mutexes
Message-ID: <20180614132905.GA7841@bombadil.infradead.org>
References: <20180614072922.8114-1-thellstrom@vmware.com>
 <20180614072922.8114-2-thellstrom@vmware.com>
 <20180614113604.GZ12198@hirez.programming.kicks-ass.net>
 <7eb10c22-57b3-1472-0a77-7f787f612217@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7eb10c22-57b3-1472-0a77-7f787f612217@vmware.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Thu, Jun 14, 2018 at 01:54:15PM +0200, Thomas Hellstrom wrote:
> On 06/14/2018 01:36 PM, Peter Zijlstra wrote:
> > Currently you don't allow mixing WD and WW contexts (which is not
> > immediately obvious from the above code), and the above hard relies on
> > that. Are there sensible use cases for mixing them? IOW will your
> > current restriction stand without hassle?
> 
> Contexts _must_ agree on the algorithm used to resolve deadlocks. With
> Wait-Die, for example, older transactions will wait if a lock is held by a
> younger transaction and with Wound-Wait, younger transactions will wait if a
> lock is held by an older transaction so there is no way of mixing them.

Maybe the compiler should be enforcing that; ie make it a different type?
