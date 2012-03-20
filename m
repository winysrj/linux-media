Return-path: <linux-media-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756569Ab2CTAIO (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 19 Mar 2012 20:08:14 -0400
Message-ID: <4F67CA67.7000202@redhat.com>
Date: Mon, 19 Mar 2012 21:08:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: linuxtv@stefanringel.de
CC: linux-media@vger.kernel.org
Subject: Re: [PATCH 04/22] mt2063: remove dect
References: <1329256066-8844-1-git-send-email-linuxtv@stefanringel.de> <1329256066-8844-4-git-send-email-linuxtv@stefanringel.de>
In-Reply-To: <1329256066-8844-4-git-send-email-linuxtv@stefanringel.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em 14-02-2012 19:47, linuxtv@stefanringel.de escreveu:
> From: Stefan Ringel <linuxtv@stefanringel.de>
> 
> Signed-off-by: Stefan Ringel <linuxtv@stefanringel.de>

Patch is also broken: it introduces some weird stuff there. Even after removing it,
still doesn't compile:

drivers/media/common/tuners/mt2063.c: In function ‘MT2063_ChooseFirstIF’:
drivers/media/common/tuners/mt2063.c:398:26: error: array type has incomplete element type
drivers/media/common/tuners/mt2063.c:429:7: error: implicit declaration of function ‘floor’ [-Werror=implicit-function-declaration]
drivers/media/common/tuners/mt2063.c:433:7: error: implicit declaration of function ‘ceil’ [-Werror=implicit-function-declaration]
drivers/media/common/tuners/mt2063.c:398:26: warning: unused variable ‘zones’ [-Wunused-variable]
cc1: some warnings being treated as errors

> ---
>  drivers/media/common/tuners/mt2063.c |  190 ----------------------------------
>  1 files changed, 0 insertions(+), 190 deletions(-)
> 
> diff --git a/drivers/media/common/tuners/mt2063.c b/drivers/media/common/tuners/mt2063.c
> index d5a9dd9..a79e4ef 100644
> --- a/drivers/media/common/tuners/mt2063.c
> +++ b/drivers/media/common/tuners/mt2063.c
> @@ -363,200 +363,17 @@ static int MT2063_Sleep(struct dvb_frontend *fe)
>  	return 0;
>  }
>  
> -/*
> - * Microtune spur avoidance
> - */
> -
> -/*  Implement ceiling, floor functions.  */
> -#define ceil(n, d) (((n) < 0) ? (-((-(n))/(d))) : (n)/(d) + ((n)%(d) != 0))
> -#define floor(n, d) (((n) < 0) ? (-((-(n))/(d))) - ((n)%(d) != 0) : (n)/(d))
> -
> -struct MT2063_FIFZone_t {
> -	s32 min_;
> -	s32 max_;
> -};
> -
> -static struct MT2063_ExclZone_t *InsertNode(struct MT2063_AvoidSpursData_t
> -					    *pAS_Info,
> -					    struct MT2063_ExclZone_t *pPrevNode)
>  {
> -	struct MT2063_ExclZone_t *pNode;
>  
> -	dprintk(2, "\n");
> -
> -	/*  Check for a node in the free list  */
> -	if (pAS_Info->freeZones != NULL) {
> -		/*  Use one from the free list  */
> -		pNode = pAS_Info->freeZones;
> -		pAS_Info->freeZones = pNode->next_;
>  	} else {
> -		/*  Grab a node from the array  */
> -		pNode = &pAS_Info->MT2063_ExclZones[pAS_Info->nZones];
> -	}
> -
> -	if (pPrevNode != NULL) {
> -		pNode->next_ = pPrevNode->next_;
> -		pPrevNode->next_ = pNode;
> -	} else {		/*  insert at the beginning of the list  */
> -
> -		pNode->next_ = pAS_Info->usedZones;
> -		pAS_Info->usedZones = pNode;
> -	}
> -
> -	pAS_Info->nZones++;
> -	return pNode;
> -}
> -
> -static struct MT2063_ExclZone_t *RemoveNode(struct MT2063_AvoidSpursData_t
> -					    *pAS_Info,
> -					    struct MT2063_ExclZone_t *pPrevNode,
> -					    struct MT2063_ExclZone_t
> -					    *pNodeToRemove)
> -{
> -	struct MT2063_ExclZone_t *pNext = pNodeToRemove->next_;
> -
> -	dprintk(2, "\n");
> -
> -	/*  Make previous node point to the subsequent node  */
> -	if (pPrevNode != NULL)
> -		pPrevNode->next_ = pNext;
> -
> -	/*  Add pNodeToRemove to the beginning of the freeZones  */
> -	pNodeToRemove->next_ = pAS_Info->freeZones;
> -	pAS_Info->freeZones = pNodeToRemove;
> -
> -	/*  Decrement node count  */
> -	pAS_Info->nZones--;
> -
> -	return pNext;
> -}
> -
> -/*
> - * MT_AddExclZone()
> - *
> - * Add (and merge) an exclusion zone into the list.
> - * If the range (f_min, f_max) is totally outside the
> - * 1st IF BW, ignore the entry.
> - * If the range (f_min, f_max) is negative, ignore the entry.
> - */
> -static void MT2063_AddExclZone(struct MT2063_AvoidSpursData_t *pAS_Info,
> -			       u32 f_min, u32 f_max)
> -{
> -	struct MT2063_ExclZone_t *pNode = pAS_Info->usedZones;
> -	struct MT2063_ExclZone_t *pPrev = NULL;
> -	struct MT2063_ExclZone_t *pNext = NULL;
> -
> -	dprintk(2, "\n");
> -
> -	/*  Check to see if this overlaps the 1st IF filter  */
> -	if ((f_max > (pAS_Info->f_if1_Center - (pAS_Info->f_if1_bw / 2)))
> -	    && (f_min < (pAS_Info->f_if1_Center + (pAS_Info->f_if1_bw / 2)))
> -	    && (f_min < f_max)) {
> -		/*
> -		 *                1        2         3      4       5        6
> -		 *
> -		 *   New entry:  |---|    |--|      |--|    |-|    |---|    |--|
> -		 *                or       or        or     or      or
> -		 *   Existing:  |--|      |--|      |--|    |---|  |-|      |--|
> -		 */
> -
> -		/*  Check for our place in the list  */
> -		while ((pNode != NULL) && (pNode->max_ < f_min)) {
> -			pPrev = pNode;
> -			pNode = pNode->next_;
> -		}
> -
> -		if ((pNode != NULL) && (pNode->min_ < f_max)) {
> -			/*  Combine me with pNode  */
> -			if (f_min < pNode->min_)
> -				pNode->min_ = f_min;
> -			if (f_max > pNode->max_)
> -				pNode->max_ = f_max;
> -		} else {
> -			pNode = InsertNode(pAS_Info, pPrev);
> -			pNode->min_ = f_min;
> -			pNode->max_ = f_max;
> -		}
> -
> -		/*  Look for merging possibilities  */
> -		pNext = pNode->next_;
> -		while ((pNext != NULL) && (pNext->min_ < pNode->max_)) {
> -			if (pNext->max_ > pNode->max_)
> -				pNode->max_ = pNext->max_;
> -			/*  Remove pNext, return ptr to pNext->next  */
> -			pNext = RemoveNode(pAS_Info, pNode, pNext);
> -		}
>  	}
>  }
>  
> -/*
> - *  Reset all exclusion zones.
> - *  Add zones to protect the PLL FracN regions near zero
> - */
> -static void MT2063_ResetExclZones(struct MT2063_AvoidSpursData_t *pAS_Info)
>  {
> -	u32 center;
>  
> -	dprintk(2, "\n");
>  
> -	pAS_Info->nZones = 0;	/*  this clears the used list  */
> -	pAS_Info->usedZones = NULL;	/*  reset ptr                  */
> -	pAS_Info->freeZones = NULL;	/*  reset ptr                  */
> -
> -	center =
> -	    pAS_Info->f_ref *
> -	    ((pAS_Info->f_if1_Center - pAS_Info->f_if1_bw / 2 +
> -	      pAS_Info->f_in) / pAS_Info->f_ref) - pAS_Info->f_in;
> -	while (center <
> -	       pAS_Info->f_if1_Center + pAS_Info->f_if1_bw / 2 +
> -	       pAS_Info->f_LO1_FracN_Avoid) {
> -		/*  Exclude LO1 FracN  */
> -		MT2063_AddExclZone(pAS_Info,
> -				   center - pAS_Info->f_LO1_FracN_Avoid,
> -				   center - 1);
> -		MT2063_AddExclZone(pAS_Info, center + 1,
> -				   center + pAS_Info->f_LO1_FracN_Avoid);
> -		center += pAS_Info->f_ref;
> -	}
>  
> -	center =
> -	    pAS_Info->f_ref *
> -	    ((pAS_Info->f_if1_Center - pAS_Info->f_if1_bw / 2 -
> -	      pAS_Info->f_out) / pAS_Info->f_ref) + pAS_Info->f_out;
> -	while (center <
> -	       pAS_Info->f_if1_Center + pAS_Info->f_if1_bw / 2 +
> -	       pAS_Info->f_LO2_FracN_Avoid) {
> -		/*  Exclude LO2 FracN  */
> -		MT2063_AddExclZone(pAS_Info,
> -				   center - pAS_Info->f_LO2_FracN_Avoid,
> -				   center - 1);
> -		MT2063_AddExclZone(pAS_Info, center + 1,
> -				   center + pAS_Info->f_LO2_FracN_Avoid);
> -		center += pAS_Info->f_ref;
> -	}
>  
> -	if (MT2063_EXCLUDE_US_DECT_FREQUENCIES(pAS_Info->avoidDECT)) {
> -		/*  Exclude LO1 values that conflict with DECT channels */
> -		MT2063_AddExclZone(pAS_Info, 1920836000 - pAS_Info->f_in, 1922236000 - pAS_Info->f_in);	/* Ctr = 1921.536 */
> -		MT2063_AddExclZone(pAS_Info, 1922564000 - pAS_Info->f_in, 1923964000 - pAS_Info->f_in);	/* Ctr = 1923.264 */
> -		MT2063_AddExclZone(pAS_Info, 1924292000 - pAS_Info->f_in, 1925692000 - pAS_Info->f_in);	/* Ctr = 1924.992 */
> -		MT2063_AddExclZone(pAS_Info, 1926020000 - pAS_Info->f_in, 1927420000 - pAS_Info->f_in);	/* Ctr = 1926.720 */
> -		MT2063_AddExclZone(pAS_Info, 1927748000 - pAS_Info->f_in, 1929148000 - pAS_Info->f_in);	/* Ctr = 1928.448 */
> -	}
> -
> -	if (MT2063_EXCLUDE_EURO_DECT_FREQUENCIES(pAS_Info->avoidDECT)) {
> -		MT2063_AddExclZone(pAS_Info, 1896644000 - pAS_Info->f_in, 1898044000 - pAS_Info->f_in);	/* Ctr = 1897.344 */
> -		MT2063_AddExclZone(pAS_Info, 1894916000 - pAS_Info->f_in, 1896316000 - pAS_Info->f_in);	/* Ctr = 1895.616 */
> -		MT2063_AddExclZone(pAS_Info, 1893188000 - pAS_Info->f_in, 1894588000 - pAS_Info->f_in);	/* Ctr = 1893.888 */
> -		MT2063_AddExclZone(pAS_Info, 1891460000 - pAS_Info->f_in, 1892860000 - pAS_Info->f_in);	/* Ctr = 1892.16  */
> -		MT2063_AddExclZone(pAS_Info, 1889732000 - pAS_Info->f_in, 1891132000 - pAS_Info->f_in);	/* Ctr = 1890.432 */
> -		MT2063_AddExclZone(pAS_Info, 1888004000 - pAS_Info->f_in, 1889404000 - pAS_Info->f_in);	/* Ctr = 1888.704 */
> -		MT2063_AddExclZone(pAS_Info, 1886276000 - pAS_Info->f_in, 1887676000 - pAS_Info->f_in);	/* Ctr = 1886.976 */
> -		MT2063_AddExclZone(pAS_Info, 1884548000 - pAS_Info->f_in, 1885948000 - pAS_Info->f_in);	/* Ctr = 1885.248 */
> -		MT2063_AddExclZone(pAS_Info, 1882820000 - pAS_Info->f_in, 1884220000 - pAS_Info->f_in);	/* Ctr = 1883.52  */
> -		MT2063_AddExclZone(pAS_Info, 1881092000 - pAS_Info->f_in, 1882492000 - pAS_Info->f_in);	/* Ctr = 1881.792 */
> -	}
> -}
>  
>  /*
>   * MT_ChooseFirstIF - Choose the best available 1st IF
> @@ -859,8 +676,6 @@ static u32 MT2063_AvoidSpurs(struct MT2063_AvoidSpursData_t *pAS_Info)
>  		do {
>  			pAS_Info->nSpursFound++;
>  
> -			/*  Raise f_IF1_upper, if needed  */
> -			MT2063_AddExclZone(pAS_Info, zfIF1 - fm, zfIF1 + fp);
>  
>  			/*  Choose next IF1 that is closest to f_IF1_CENTER              */
>  			new_IF1 = MT2063_ChooseFirstIF(pAS_Info);
> @@ -1617,11 +1432,6 @@ static u32 MT2063_Tune(struct mt2063_state *state, u32 f_in)
>  			     state->AS_Data.f_LO1_Step,
>  			     state->AS_Data.f_ref) - f_in;
>  
> -	/*
> -	 * Calculate frequency settings.  f_IF1_FREQ + f_in is the
> -	 * desired LO1 frequency
> -	 */
> -	MT2063_ResetExclZones(&state->AS_Data);
>  
>  	f_IF1 = MT2063_ChooseFirstIF(&state->AS_Data);
>  

