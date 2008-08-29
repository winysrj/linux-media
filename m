Return-path: <video4linux-list-bounces@redhat.com>
Date: Fri, 29 Aug 2008 19:32:27 -0300
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: David Howells <dhowells@redhat.com>
Message-ID: <20080829193227.1494de9b@mchehab.chehab.org>
In-Reply-To: <20080827134638.19980.39537.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
	<20080827134638.19980.39537.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: David Howells <dhowells@redhat.com>, Serge Hallyn <serue@us.ibm.com>,
	linux-security-module@vger.kernel.org,
	video4linux-list@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/59] CRED: Wrap task credential accesses in video
 input drivers
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

On Wed, 27 Aug 2008 14:46:39 +0100
David Howells <dhowells@redhat.com> wrote:

> Wrap access to task credentials so that they can be separated more easily from
> the task_struct during the introduction of COW creds.
> 
> Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().
> 
> Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
> sense to use RCU directly rather than a convenient wrapper; these will be
> addressed by later patches.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> Reviewed-by: James Morris <jmorris@namei.org>
> Acked-by: Serge Hallyn <serue@us.ibm.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>

Acked-by: Mauro Carvalho Chehab <mchehab@infradead.org>

I'll add it on my tree and keep it for linux-next.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
